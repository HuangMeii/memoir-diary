// Memoir — static login prototype behaviour.
// The artwork turns a page and sweeps the branch while the visitor is typing.
// Everything here is presentation only: no request ever leaves the page.

(() => {
  'use strict';

  const body = document.body;
  const root = document.documentElement;
  const form = document.getElementById('login-form');
  const username = document.getElementById('username');
  const password = document.getElementById('password');
  const fields = [username, password];
  const errorBox = document.getElementById('form-error');
  const toggle = document.querySelector('.field__toggle');
  const themeButton = document.querySelector('[data-demo-theme]');
  const playButton = document.querySelector('[data-demo-play]');

  // --- Typing state ------------------------------------------------------
  // Focus drives the artwork, and typed text keeps it open, so walking away
  // from a filled-in form does not snap the page shut behind the user.
  const syncWriting = () => {
    const active = document.activeElement;
    const typing =
      fields.includes(active) ||
      active === toggle ||
      fields.some((field) => field.value.length > 0);
    body.classList.toggle('is-writing', typing);
  };

  // Moving focus between the two fields fires `blur` before the next `focus`;
  // re-reading `activeElement` on the next task avoids a one-frame flicker.
  const syncWritingSoon = () => window.setTimeout(syncWriting, 0);

  fields.forEach((field) => {
    field.addEventListener('focus', syncWriting);
    field.addEventListener('blur', syncWritingSoon);
    field.addEventListener('input', () => {
      errorBox.hidden = true;
      syncWriting();
    });
  });

  // --- Password visibility -----------------------------------------------
  toggle.addEventListener('click', () => {
    const shown = toggle.getAttribute('aria-pressed') === 'true';
    password.type = shown ? 'password' : 'text';
    toggle.setAttribute('aria-pressed', String(!shown));
    toggle.setAttribute('aria-label', shown ? 'Hiện mật khẩu' : 'Ẩn mật khẩu');
    syncWriting();
  });

  // --- Submit ------------------------------------------------------------
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    errorBox.hidden = false;
  });

  // --- Theme -------------------------------------------------------------
  themeButton.addEventListener('click', () => {
    const next = root.dataset.theme === 'dark' ? 'light' : 'dark';
    root.dataset.theme = next;
    themeButton.textContent = next === 'dark' ? 'Chế độ sáng' : 'Chế độ tối';
  });

  // --- Replay ------------------------------------------------------------
  // `is-demo` mirrors what typing triggers without touching the fields.
  playButton.addEventListener('click', () => {
    body.classList.remove('is-demo');
    // Flush the removal so the same class re-adding animates again.
    void body.offsetWidth;
    window.setTimeout(() => body.classList.add('is-demo'), 40);
    window.setTimeout(() => body.classList.remove('is-demo'), 1900);
  });
})();
