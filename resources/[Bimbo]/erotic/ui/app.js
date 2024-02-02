window.addEventListener('message', (event) => {
    var item = event.data;
    switch (item.type) {
        case 'show':
            document.querySelector('#combat').style.opacity = item.value ? '1' : '0';
            break;

        case 'xhair':
            document.querySelector('.xhair-container').style.opacity = item.cross ? '0' : '1';
            break;

        case 'xhair_colour':
            document.querySelector('.xhair').style.setProperty('background-color', item.color || 'rgb(255, 255, 255)');
            break;

        case 'ammo':
            updateAmmoDisplay(item.data);
            break;

        case 'scope':
            document.querySelector('.scope').classList.toggle('visible', item.value === true);
            break;

        case 'showWatermark':
            document.querySelector('.WaterMark').classList.toggle('hide', item.value !== true);
            break;

        case 'updateWatermark':
            document.querySelector('.WM-data-desc').textContent = item.value;
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