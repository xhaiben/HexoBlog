{% if theme.changyan %}
  <script type="text/javascript">
    (function () {
      var cy = document.createElement("div");
      cy.id = "SOHUCS";
      document.getElementById('comments').appendChild(cy);
    })();
  </script>
  <script charset="utf-8" type="text/javascript" src="https://changyan.sohu.com/upload/changyan.js"></script>

  <script type="text/javascript">
    window.changyan.api.config({
      appid: 'cysM5e4Ro',
      conf: 'prod_69e5aeeaaea3dc7952fb661f48ac6450'
    });
  </script>
  <script type="text/javascript">
    var result = false;
    function deleteE() {
      var CY = document.getElementById("SOHUCS");
      if (CY) {
        var boardEnter = document.getElementsByClassName("cy-board-enter");
        boardEnter[0].style.display = "none";
        result = true;
      }
    }
    var In = window.setInterval(deleteE, 10);
    if (result) {
      window.clearInterval(In);
    }
  </script>
{% endif %}
