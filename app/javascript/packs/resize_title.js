const target = document.querySelector("#episodes");
const title = document.querySelector("#episodes-title");

const reSize = () => {
  let width = target.offsetWidth;
  title.style.width = `${width}px`;
}

reSize();

window.addEventListener('resize', reSize)
