document.querySelectorAll('img[alt*="#zoom"]').forEach(item => {
    item.classList.add("zoom");
    item.addEventListener('click', function () {
        this.classList.toggle('image-zoom-large');
    });
});