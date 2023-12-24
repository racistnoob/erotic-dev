window.onload = () => { 
    window.addEventListener('message', (event) => {            
        var item = event.data;
        if (item !== undefined && item.type === "updateHUD") {

            $("#hud-container").show();

            var health = item.health;
            var armor = item.armor;

            $('#health-bar').css("width", health + "%");
            $('#armor-bar').css("width", armor + "%");

        } else {
            $("#hud-container").hide();
        }
    });
};
