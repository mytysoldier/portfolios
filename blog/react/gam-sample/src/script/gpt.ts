export function initializeGpt() {
  window.googletag = window.googletag || { cmd: [] };

  googletag.cmd.push(() => {
    googletag
      .defineSlot(
        "/6355419/Travel/Europe/France/Paris",
        [300, 250],
        "gam-display"
      )
      ?.addService(googletag.pubads());

    googletag.enableServices();

    googletag.display("gam-display");
  });
}
