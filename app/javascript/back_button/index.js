import onBackButtonClick from './on_back_button_click';

export default () => {
  const backButtons = document.querySelectorAll('[data-back-button]');

  for (const backButton of backButtons) {
    backButton.addEventListener('click', onBackButtonClick);
  }
};
