const episodes = document.querySelector("#episodes");
const management = document.querySelector("#manage-shows");
const episodesTitle = document.querySelector("#episodes-title");
const managementTitle = document.querySelector("#management-title");

const reSize = () => {
  let width = episodes.offsetWidth;
  episodesTitle.style.width = `${width}px`;
  managementWidth = management.offsetWidth;
  managementTitle.style.width = `${managementWidth}px`;

}

reSize();

window.addEventListener('resize', reSize)
