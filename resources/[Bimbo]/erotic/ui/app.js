window.addEventListener('message', (event) => {
    if (event.data.type === 'show') {
        let ele = document.querySelector('#combat');
        ele.style.opacity = event.data.value ? '1' : '0';

        let xhair = document.querySelector('.xhair-container');
        xhair.style.opacity = event.data.cross ? '0' : '1';

    } else if (event.data.type === 'ammo') {
        updateAmmoDisplay(event.data.data);
    }

    var scopeElement = document.querySelector('.scope');

    var item = event.data;
    if (item.type === "scope") {
        if (item.value === true) {
            scopeElement.classList.add('visible');
        } else {
            scopeElement.classList.remove('visible');
        }
    }
});

const ammoCountElement = document.querySelector('.ammo-count');
const ammoMaxElement = document.querySelector('.ammo-max');

function updateAmmoDisplay(data) {
    if (data.ClipAmmo === 0 && data.MaxAmmo === 0) {
        ammoCountElement.style.display = 'none';
        ammoMaxElement.style.display = 'none';
    } else {
        ammoCountElement.textContent = data.ClipAmmo;
        ammoMaxElement.textContent = `/ ${data.MaxAmmo}`;
        ammoCountElement.style.display = 'inline';
        ammoMaxElement.style.display = 'inline';
    }
}