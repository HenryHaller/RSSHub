const target = document.querySelector("#episodes");
const title = document.querySelector("#episodes-title");

const reSize = () => {
  let width = target.offsetWidth;
  title.style.width = `${width}px`;
  console.log(width);
}

reSize();

window.addEventListener('resize', reSize)
