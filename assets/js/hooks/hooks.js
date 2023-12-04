let Hooks = {};

Hooks.Marker = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      console.log("Hook on click");
    });
  },
};

export default Hooks;
