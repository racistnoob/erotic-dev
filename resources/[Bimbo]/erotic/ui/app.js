window.addEventListener('message', (event) => {
    if (event.data.type === 'show') {
        let ele = document.querySelector('#combat');
        if (event.data.value) {
            ele.style.opacity = '1'; // Fade in
        } else {
            ele.style.opacity = '0'; // Fade out
        }
    } else if (event.data.type === 'ammo') {
        updateAmmoDisplay(event.data.data);
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action === 'toggleInfo') {
        toggleInfoDisplay();
    }
});

function toggleInfoDisplay() {
    var info = document.querySelector('.information');
    info.style.display = (info.style.display === 'flex' ? 'none' : 'flex');
}

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
