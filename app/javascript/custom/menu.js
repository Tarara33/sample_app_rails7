// メニュー操作

document.addEventListener("turbo:load", function() {
    let hamburger = document.querySelector("#hamburger");
    hamburger.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#navbar-menu");
      menu.classList.toggle("collapse")
    });
});

// トグルリスナーを追加してクリックをリッスンする
document.addEventListener("turbo:load", function() {
  let account = document.querySelector("#account");
  account.addEventListener("click", function(event) {
    event.preventDefault();
    let menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active");
  });
});
