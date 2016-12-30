console.log("哈哈，你好。");
function reward() {
    var qr = document.getElementById('QR');
    if (qr.style.display === 'none') {
        qr.style.display='block';
    } else {
        qr.style.display='none'
    }
}
