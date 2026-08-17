"use strict";

const $ = (sel, root = document) => root.querySelector(sel);
const $$ = (sel, root = document) => [...root.querySelectorAll(sel)];

function escapeHTML(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function copyText(text) {
  if (navigator.clipboard && window.isSecureContext) {
    return navigator.clipboard.writeText(text);
  }
  return new Promise((resolve, reject) => {
    const ta = document.createElement("textarea");
    ta.value = text;
    ta.style.position = "fixed";
    ta.style.opacity = "0";
    document.body.appendChild(ta);
    ta.select();
    try {
      document.execCommand("copy");
      resolve();
    } catch (e) {
      reject(e);
    }
    ta.remove();
  });
}

function showToast(msg) {
  let toast = $(".toast");
  if (!toast) {
    toast = document.createElement("div");
    toast.className = "toast";
    document.body.appendChild(toast);
  }
  toast.innerHTML = `<span class="tick">✓</span>${escapeHTML(msg)}`;
  requestAnimationFrame(() => toast.classList.add("show"));
  clearTimeout(toast._t);
  toast._t = setTimeout(() => toast.classList.remove("show"), 2400);
}

function cardHTML(s) {
  const tags = s.tags.map((t) => `<span>#${escapeHTML(t)}</span>`).join("");
  const featured = s.featured ? `<div class="featured-flag">FEATURED</div>` : "";
  return `
  <article class="card reveal" data-id="${escapeHTML(s.id)}">
    ${featured}
    <div class="card-top">
      <span class="cat">${escapeHTML(s.category)}</span>
      <span class="ver">v${escapeHTML(s.version)}</span>
    </div>
    <h3>${escapeHTML(s.title)}</h3>
    <p class="desc">${escapeHTML(s.description)}</p>
    <div class="tags">${tags}</div>
    <div class="meta">
      <span>📦 ${escapeHTML(s.size || "?")}</span>
      <span>🕒 ${escapeHTML(s.updated)}</span>
    </div>
    <div class="card-actions">
      <button class="btn btn-ghost btn-sm" data-copy="${escapeHTML(s.download)}">Copy link</button>
      <a class="btn btn-primary btn-sm" href="${escapeHTML(s.download)}" target="_blank" rel="noopener">Get script ↗</a>
    </div>
  </article>`;
}

let DATA = null;
let activeCategory = "All";
let searchQuery = "";

function categories() {
  const set = new Set(DATA.scripts.map((s) => s.category));
  return ["All", ...set];
}

function filtered() {
  return DATA.scripts.filter((s) => {
    const okCat = activeCategory === "All" || s.category === activeCategory;
    const q = searchQuery.trim().toLowerCase();
    const okQ =
      !q ||
      s.title.toLowerCase().includes(q) ||
      s.description.toLowerCase().includes(q) ||
      s.tags.some((t) => t.toLowerCase().includes(q)) ||
      s.category.toLowerCase().includes(q);
    return okCat && okQ;
  });
}

function renderScripts(target) {
  const list = filtered();
  target.innerHTML = list.map(cardHTML).join("");

  const empty = $(".empty-state");
  if (empty) empty.style.display = list.length ? "none" : "block";
  observeReveals();
  bindCardEvents(target);
}

function renderChips(container) {
  container.innerHTML = categories()
    .map(
      (c) =>
        `<button class="chip${c === activeCategory ? " active" : ""}" data-cat="${escapeHTML(c)}">${escapeHTML(c)}</button>`
    )
    .join("");
  $$(".chip", container).forEach((chip) =>
    chip.addEventListener("click", () => {
      activeCategory = chip.dataset.cat;
      renderChips(container);
      renderScripts($("#scriptsGrid"));
    })
  );
}

function bindCardEvents(root) {
  $$("[data-copy]", root).forEach((btn) =>
    btn.addEventListener("click", () => {
      copyText(btn.dataset.copy)
        .then(() => showToast("Link copied — paste it into your executor!"))
        .catch(() => showToast("Copy failed — please copy the link manually"));
    })
  );
}

function observeReveals() {
  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) {
          e.target.classList.add("visible");
          io.unobserve(e.target);
        }
      });
    },
    { threshold: 0.08 }
  );
  $$(".reveal:not(.visible)").forEach((el) => io.observe(el));
}

function renderStats() {
  const cats = categories().length - 1;
  const el = $("#statsTarget");
  if (!el || !DATA) return;
  const updated =
    DATA.scripts
      .map((s) => s.updated)
      .sort()
      .pop() || "—";
  el.innerHTML = `
    <div class="reveal visible">
      <div class="num">${DATA.scripts.length}<em>+</em></div>
      <div class="lbl">Scripts</div>
    </div>
    <div class="reveal visible">
      <div class="num">${cats}<em>+</em></div>
      <div class="lbl">Categories</div>
    </div>
    <div class="reveal visible">
      <div class="num">${escapeHTML(updated)}</div>
      <div class="lbl">Latest update</div>
    </div>`;
}

async function init() {
  try {
    const res = await fetch("data/scripts.json", { cache: "no-store" });
    if (!res.ok) throw new Error("HTTP " + res.status);
    DATA = await res.json();
  } catch (err) {
    const fallback = $("#scriptsGrid");
    if (fallback) {
      fallback.innerHTML = `
        <div class="empty-state" style="display:block;grid-column:1/-1">
          <div class="big">⚠️</div>
          <p>Couldn't load <span class="mono">data/scripts.json</span>.</p>
          <p style="margin-top:8px;font-size:13px">Preview with a local server: <code>python3 -m http.server</code></p>
        </div>`;
    }
    console.warn("Failed to load scripts.json:", err);
    return;
  }

  const grid = $("#scriptsGrid");
  if (grid) {
    renderChips($("#chips"));
    renderScripts(grid);

    const search = $("#searchInput");
    if (search) {
      search.addEventListener("input", (e) => {
        searchQuery = e.target.value;
        renderScripts(grid);
      });
    }
  }

  const featured = $("#featuredGrid");
  if (featured) {
    featured.innerHTML = DATA.scripts.filter((s) => s.featured).map(cardHTML).join("");
    bindCardEvents(featured);
  }

  if (DATA.owner) {
    const bio = $("#bioText");
    if (bio) bio.textContent = DATA.owner.bio;
    const bioEm = $("#bioMono");
    if (bioEm) bioEm.textContent = DATA.owner.bio;
    const discordLinks = $$("[data-discord]");
    discordLinks.forEach((a) => (a.href = DATA.owner.discord));
  }

  renderStats();
  observeReveals();
}

document.addEventListener("DOMContentLoaded", init);
