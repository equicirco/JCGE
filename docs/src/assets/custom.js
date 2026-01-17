document.addEventListener("DOMContentLoaded", () => {
  const sidebar = document.querySelector(".docs-sidebar");
  if (!sidebar) {
    return;
  }

  if (sidebar.querySelector("#jcge-sidebar-logo")) {
    return;
  }

  const packageName = sidebar.querySelector(".docs-package-name");
  if (!packageName) {
    return;
  }

  const base = (window.documenterBaseURL || ".").replace(/\/$/, "");

  const wrapper = document.createElement("div");
  wrapper.id = "jcge-sidebar-logo";
  wrapper.className = "jcge-sidebar-logo";
  wrapper.innerHTML = `
    <img class="jcge-logo-light" src="${base}/assets/jcge_logo_light.png" alt="JCGE">
    <img class="jcge-logo-dark" src="${base}/assets/jcge_logo_dark.png" alt="JCGE">
  `;

  sidebar.insertBefore(wrapper, packageName);
});
