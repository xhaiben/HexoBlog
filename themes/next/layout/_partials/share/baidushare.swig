{% if theme.baidushare.type === "button" %}
  <div class="bdsharebuttonbox">
    <a class="ttqq" data-cmd="sqq" title="分享到QQ好友"></a>
    <a class="ttwx" data-cmd="weixin" href="#" title="分享到微信"></a>
    <a class="ttqzone" data-cmd="qzone" title="分享到QQ空间"></a>
    <a class="ttsina" data-cmd="tsina" title="分享到新浪微博"></a>
    <a class="ttbdhome" data-cmd="bdhome" title="分享到百度新首页"></a>
    <a class="tttqq" data-cmd="tqq" title="分享到腾讯微博"></a>
    <a class="tthuaban" data-cmd="huaban" title="分享到花瓣"></a>
    <a class="ttfbook" data-cmd="fbook" title="分享到Facebook"></a>
    <a class="ttmore" data-cmd="more"></a>
  </div>
  <script>
    window._bd_share_config = {
      "common": {
        "bdText": "",
        "bdMini": "2",
        "bdMiniList": false,
        "bdPic": ""
      },
      "share": {
        "bdSize": "24",
        "bdStyle": "0"
      },
      "image": {
        "viewList": ["tsina", "douban", "sqq", "qzone", "weixin", "twi", "fbook"],
        "viewText": "分享到：",
        "viewSize": "24"
      }
    }
  </script>
{% elseif theme.baidushare.type === "slide" %}
  <script>
    window._bd_share_config = {
      "common": {
        "bdText": "",
        "bdMini": "1",
        "bdMiniList": false,
        "bdPic": ""
      },
      "image": {
        "viewList": ["tsina", "douban", "sqq", "qzone", "weixin", "twi", "fbook"],
        "viewText": "分享到：",
        "viewSize": "16"
      },
      "slide": {
        "bdImg": "5",
        "bdPos": "left",
        "bdTop": "100"
      }
    }
  </script>
{% endif %}
<script>
  with (document)0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = '//bdimg.share.baidu.com/static/api/js/share.js?cdnversion=' + ~(-new Date() / 36e5)];
</script>
