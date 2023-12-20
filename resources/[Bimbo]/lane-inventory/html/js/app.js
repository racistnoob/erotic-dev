let cursorX = 0;
let cursorY = 0;

document.onmousemove = function (event) {
    cursorX = event.pageX;
    cursorY = event.pageY;

    if (self.draggedData) {
        document.getElementById('draggedItem').style.left = '' + cursorX - 50 + 'px';
        document.getElementById('draggedItem').style.top = '' + cursorY - 50 + 'px';
    }
}

document.onmouseup = function (event) {
    self.draggedData = null;
    $('#draggedItem').css('opacity', 0.0);
    document.getElementById('draggedItem').innerHTML = "";
}

$(function () {
    $(document).keydown(function (e) {
        if (e.keyCode == 16) {
            self.shiftPressed = true;
        }
    });

    $(document).keyup(function (e) {
        self.shiftPressed = false;
    });
})

Vue.component('verte', Verte);

const app = new Vue({
    el: "#app",
    data: {
        DEVELOPER: false,

        opened: true,

        playerStaticData: {},

        mainInventory: [],
        secondInventory: [],
        secondInventoryStaticData: {}, // not exactly static, because we are changing it every time.

        shiftPressed: false,
        hoveredItemMain: null,
        hoveredItemSecond: null,

        isMale: true,

        count: 0,

        nearbyplayers: {
            opened: false,
            players: []
        },

        notifs: {
            slots: [],
            items: [],
            iteminterval: null,
            slotinterval: null
        },
        settings: {
            opened: false,
            selectedColoring: null,

            setters: {
                sfx: {
                    name: _U('settings_sfx'),
                    checkbox: true,
                    set: localStorage['sfx'] == undefined ? 'on' : localStorage['sfx'],
                    default: 'on'
                },
                charactername: {
                    name: _U('settings_charactername'),
                    checkbox: true,
                    set: localStorage['charactername'] == undefined ? 'on' : localStorage['charactername'],
                    default: 'on'
                },
                background: {
                    name: _U('settings_background'),
                    checkbox: true,
                    set: localStorage['background'] == undefined ? 'on' : localStorage['background'],
                    default: 'on'
                },
                blur: {
                    name: _U('settings_blur'),
                    checkbox: true,
                    set: localStorage['blur'] == undefined ? 'on' : localStorage['blur'],
                    default: 'on'
                },
                itemdescription: {
                    name: _U('settings_itemdescription'),
                    checkbox: true,
                    set: localStorage['itemdescription'] == undefined ? 'on' : localStorage['itemdescription'],
                    default: 'off'
                },
                itemnames: {
                    name: _U('settings_itemnames'),
                    checkbox: true,
                    set: localStorage['itemnames'] == undefined ? 'on' : localStorage['itemnames'],
                    default: 'on'
                },
                slots: {
                    name: _U('settings_slots'),
                    checkbox: true,
                    set: localStorage['slots'] == undefined ? 'on' : localStorage['slots'],
                    default: 'on'
                },
                itembg_1: {
                    name: _U('settings_itembg_1'),
                    color: true,
                    set: localStorage['itembg_1'] == undefined ? 'rgb(20, 20, 20, 0.5)' : localStorage['itembg_1'],
                    default: 'rgb(20, 20, 20, 0.5)'
                },
                itembg_2: {
                    name: _U('settings_itembg_2'),
                    color: true,
                    set: localStorage['itembg_2'] == undefined ? 'rgb(40, 40, 40, 0.65)' : localStorage['itembg_2'],
                    default: 'rgb(40, 40, 40, 0.65)'
                },
                weightbg_1: {
                    name: _U('settings_weightbg_1'),
                    color: true,
                    set: localStorage['weightbg_1'] == undefined ? 'rgb(200,200,200)' : localStorage['weightbg_1'],
                    default: 'rgb(200,200,200)'
                },
                weightbg_2: {
                    name: _U('settings_weightbg_2'),
                    color: true,
                    set: localStorage['weightbg_2'] == undefined ? 'rgb(111, 183, 22)' : localStorage['weightbg_2'],
                    default: 'rgb(111, 183, 22)'
                }
            }
        },

        rgb: null
    },
    computed: {
        itembgcoloring() {
            return `linear-gradient(150deg, ${this.settings.setters.itembg_1.set} 0%, ${this.settings.setters.itembg_2.set} 100%)`
        }
    },
    watch: {
        'settings.setters.blur.set': function (state) {
            this.sendEvent('nui:zbrp:blurState', state)
        },
        opened(state) {
            this.sendEvent('nui:zbrp:openedState', {
                state: state,
                blur: this.settings.setters.blur.set
            })

            if (state == false) { // resetting the data
                this.secondInventory = [];
                this.secondInventoryStaticData = {};
                this.nearbyplayers.opened = false;
                this.nearbyplayers.players = [];
            }
        }
    },
    mounted: function () {
        if (this.DEVELOPER == false) {
            this.opened = false;
        }
        else {
            this.opened = true;
            this.mainInventory = [{ "itemdata": { "description": "Kukorica az egészséges.", "deletable": true, "item": "corn", "stackable": true, "type": "food", "weight": 1.25, "formatname": "Kukorica" }, "quantity": 5, "item": "corn" }, { "itemdata": { "description": "Kenyér az finom.", "deletable": true, "item": "bread", "stackable": true, "type": "food", "weight": 1.25, "formatname": "Kenyér" }, "quantity": 1, "item": "bread" }, "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"]
            $("body").css('background', 'rgb(60,60,60)')
            this.secondInventory = [{ "itemdata": { "description": "Kenyér az finom.", "deletable": true, "item": "bread", "stackable": true, "type": "food", "weight": 1.25, "formatname": "Kenyér" }, "quantity": 1, "item": "bread" }, "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty"]
            this.secondInventoryStaticData = {
                maxweight: 1000
            }
            this.playerStaticData = {
                maxweight: 100,
                name: 'Ray Harrington (1)'
            }
        }

        this.sendEvent('nui:zbrp:mounted')
    },
    methods: {
        sendEvent(eventName, args = []) {
            if (typeof GetParentResourceName === 'function') {
                $.post(`https://${GetParentResourceName()}/${eventName}`, JSON.stringify(args));
            }
        },
        give() {
            if (this.draggedData.inventoryType == 'main') {
                if (this.mainInventory[this.draggedData.inventoryIndex]) {
                    this.nearbyplayers.savedItemReference = this.draggedData;
                    $.post(`https://${GetParentResourceName()}/getNearbyPlayers`).then((players) => {
                        this.nearbyplayers.opened = true;
                        this.nearbyplayers.players = players;
                    });
                }
            }
        },
        giveItemToTarget(targetSrc) {
            const ref = this.nearbyplayers.savedItemReference;
            if (ref && ref.inventoryType == 'main') {
                if (this.mainInventory[ref.inventoryIndex]) {
                    let darab = parseInt(this.count);
                    if (isNaN(darab) || darab < 1) {
                        darab = this.mainInventory[ref.inventoryIndex].quantity;
                    }

                    this.sendEvent('nui:zbrp:giveItemToTarget', {
                        index: ref.inventoryIndex + 1,
                        count: parseInt(darab),
                        targetSrc: targetSrc
                    })

                    this.nearbyplayers.opened = false;
                    this.nearbyplayers.players = [];
                }
            }
        },
        slotNotification(name, formatname) {
            if (this.notifs.slots.length > 5) {
                this.notifs.slots.pop();
            }

            let id = 0;
            while (this.notifs.slots.filter(a => a.unique == id).length > 0) {
                id++;
            }

            this.notifs.slots.push({
                unique: id,
                name: name,
                formatname: formatname.toUpperCase(),
                time: 3
            })

            if (!this.slotinterval) {
                this.slotinterval = setInterval(() => {
                    this.notifs.slots.forEach((a, index) => {
                        a.time--;
                        if (a.time < 1) {
                            this.notifs.slots.splice(index, 1);

                            if (this.notifs.slots.length < 1) {
                                if (this.slotinterval) {
                                    clearInterval(this.slotinterval)
                                    this.slotinterval = null;
                                }
                            }
                        }
                    });
                }, 1000);
            }
        },
        itemNotification(name, formatname, count) {
            if (this.notifs.items.length > 5) {
                this.notifs.items.pop();
            }

            let id = 0;
            while (this.notifs.items.filter(a => a.unique == id).length > 0) {
                id++;
            }

            this.notifs.items.push({
                unique: id,
                name: name,
                formatname: formatname.toUpperCase(),
                count: count,
                time: 3
            })

            if (!this.iteminterval) {
                this.iteminterval = setInterval(() => {
                    this.notifs.items.forEach((a, index) => {
                        a.time--;
                        if (a.time < 1) {
                            this.notifs.items.splice(index, 1);

                            if (this.notifs.items.length < 1) {
                                if (this.iteminterval) {
                                    clearInterval(this.iteminterval);
                                    this.iteminterval = null;
                                }
                            }
                        }
                    });
                }, 1000);
            }
        },
        useItem() {
            if (this.draggedData.inventoryType == 'main') {
                if (this.mainInventory[this.draggedData.inventoryIndex]) {
                    let darab = parseInt(this.count);
                    if (isNaN(darab) || darab < 1) {
                        darab = this.mainInventory[this.draggedData.inventoryIndex].quantity;
                    }

                    this.sendEvent('nui:zbrp:useItem', parseInt(this.draggedData.inventoryIndex + 1))
                }
            }
        },
        throwItem() {
            if (this.draggedData.inventoryType == 'main') {
                if (this.mainInventory[this.draggedData.inventoryIndex]) {
                    let darab = parseInt(this.count);
                    if (isNaN(darab) || darab < 1) {
                        darab = this.mainInventory[this.draggedData.inventoryIndex].quantity;
                    }

                    this.sendEvent('nui:zbrp:throwItem', {
                        index: this.draggedData.inventoryIndex + 1,
                        count: parseInt(darab)
                    })
                }
            }
        },
        resetSettings() {
            localStorage.clear();

            for (const key in this.settings.setters) {
                this.settings.setters[key].set = this.settings.setters[key].default;
            }
        },
        settings_enabled(key) {
            if (this.settings.setters[key]) {
                return this.settings.setters[key].set == 'on' ? true : false;
            }
        },
        colorChanged() {
            if (this.coloringValid() == true) {
                localStorage[this.settings.selectedColoring] = this.settings.setters[this.settings.selectedColoring].set;
            }
        },
        coloringValid() {
            if (this.settings.selectedColoring != null) {
                const a = this.settings.setters[this.settings.selectedColoring];
                if (a && a.color) {
                    return true;
                }
            }
        },
        setSettingsBool(key, value) {
            value.set = value.set == 'on' ? 'off' : 'on'
            localStorage[key] = value.set;
        },
        inventoryWeight(inventoryitems) {
            let weight = 0;
            if (inventoryitems && Array.isArray(inventoryitems)) {
                inventoryitems.forEach((a) => {
                    if (a != 'empty') {
                        weight += (a.itemdata.weight * a.quantity);
                    }
                });
            }
            return this.formatMoney(weight, 2);
        },
        getImage(itemData) {
            if (itemData.image) {
                return 'img/items/' + itemData.image + '.png'
            } else {
                return 'img/items/' + itemData.item + '.png'
            }
        },
        isEmpty(a) {
            return a == 'empty' ? true : false;
        },
        endDrag(inventoryType, index) {
            if (this.draggedData == null) return;

            if (this.draggedData.inventoryType == 'main') {
                if (this.mainInventory[this.draggedData.inventoryIndex]) {
                    let darab = parseInt(this.count)
                    if (isNaN(darab) || darab < 1) {
                        darab = this.mainInventory[this.draggedData.inventoryIndex].quantity;
                    }

                    if (inventoryType == 'second') { // áthúzás second
                        this.sendEvent('nui:zbrp:moveToSecond', {
                            count: darab,
                            index: this.draggedData.inventoryIndex + 1,
                            droppedTo: index + 1
                        })
                        this.PlaySound('pop.wav')
                    }
                    else if (inventoryType == 'main') { //mozgatás inventoryn belül
                        if (this.draggedData.inventoryIndex == index) return; // ez nagyon fontos

                        this.sendEvent('nui:zbrp:moveInside', {
                            count: darab,
                            index: this.draggedData.inventoryIndex + 1,
                            droppedTo: index + 1,
                            inventoryType: 'main'
                        })
                        this.PlaySound('pop.wav')
                    }

                }
            }
            else if (this.draggedData.inventoryType == 'second') {
                if (this.secondInventory[this.draggedData.inventoryIndex]) {
                    let darab = parseInt(this.count);
                    if (isNaN(darab) || darab < 1) {
                        darab = this.secondInventory[this.draggedData.inventoryIndex].quantity;
                    }

                    if (inventoryType == 'main') { // áthúzás inventoryba

                        this.sendEvent('nui:zbrp:moveToFirst', {
                            count: darab,
                            index: this.draggedData.inventoryIndex + 1,
                            droppedTo: index + 1
                        })
                        this.PlaySound('pop.wav')
                    }
                    else if (inventoryType == 'second') { // mozgatás inside
                        if (this.draggedData.inventoryIndex == index) return; // fontos


                        this.sendEvent('nui:zbrp:moveInside', {
                            count: darab,
                            index: this.draggedData.inventoryIndex + 1,
                            droppedTo: index + 1,
                            inventoryType: 'second'
                        })
                        this.PlaySound('pop.wav')
                    }

                }
            }
        },
        startDrag(inventoryType, index) {
            if (inventoryType == 'main') {
                if (this.shiftPressed) {
                    this.sendEvent('nui:zbrp:instantToSecond', parseInt(index + 1))
                    this.PlaySound('pop.wav')
                }
                else {
                    const el = document.getElementById('main-' + index)
                    if (this.mainInventory[index] != 'empty' && this.mainInventory[index] != undefined) {
                        document.getElementById('draggedItem').innerHTML = el.innerHTML;
                        document.getElementById('draggedItem').style.left = cursorX - 50
                        document.getElementById('draggedItem').style.top = cursorY - 50
                        document.getElementById('draggedItem').style.opacity = '0.5';

                        this.draggedData = {
                            inventoryType: inventoryType,
                            inventoryIndex: index
                        }
                        this.PlaySound('click.mp3')
                    }
                }
            }
            else if (inventoryType == 'second') {
                if (this.shiftPressed) {
                    this.sendEvent('nui:zbrp:instantToMain', parseInt(index + 1))
                    this.PlaySound('pop.wav')
                } else {
                    const el = document.getElementById('second-' + index);

                    if (this.secondInventory[index] != 'empty' && this.secondInventory[index] != undefined) {
                        document.getElementById('draggedItem').innerHTML = el.innerHTML;
                        document.getElementById('draggedItem').style.left = cursorX - 50
                        document.getElementById('draggedItem').style.top = cursorY - 50
                        document.getElementById('draggedItem').style.opacity = '0.5';

                        this.draggedData = {
                            inventoryType: inventoryType,
                            inventoryIndex: index
                        }
                        this.PlaySound('click.mp3')
                    }
                }
            }
        },
        getPercentage(current, max) {
            let a = (current * 100) / max;
            if (a > 100) a = 100;
            return a;
        },
        PlaySound(sound, volume) {
            if (this.settings.setters.sfx.set == 'on') {
                new Howl({
                    src: [`sounds/${sound}`],
                    autoplay: true,
                    loop: false,
                    volume: volume ? volume : 0.015,
                });
            }
        },
        formatMoney: function (n, c, d, t) {
            var c = isNaN((c = Math.abs(c))) ? 0 : c,
                d = d == undefined ? "." : d,
                t = t == undefined ? "," : t,
                s = n < 0 ? "-" : "",
                i = String(parseInt((n = Math.abs(Number(n) || 0).toFixed(c)))),
                j = (j = i.length) > 3 ? j % 3 : 0;
            return (
                s +
                (j ? i.substr(0, j) + t : "") +
                i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) +
                (c ?
                    d +
                    Math.abs(n - i)
                        .toFixed(c)
                        .slice(2) :
                    "")
            );
        },
    },
    template: "#app",
});

const self = app;

window.addEventListener("message", (event) => {
    if (event.data.action == 'openInventory') {
        self.opened = true;
        self.isMale = event.data.isMale;
    }
    else if (event.data.action == 'updatePlayerInventory') {
        self.mainInventory = event.data.inventory;
    }
    else if (event.data.action == 'setPlayerStaticData') {
        self.playerStaticData = {
            maxweight: event.data.maxweight,
            name: event.data.name
        }
    }
    else if (event.data.action == 'updateSecondInventory') {
        self.secondInventory = event.data.inventory;
        self.secondInventoryStaticData.maxweight = event.data.maxweight;
    }
    else if (event.data.action == 'itemNotification') {
        self.itemNotification(event.data.name, event.data.formatname, event.data.count);
    }
    else if (event.data.action == 'slotNotification') {
        self.slotNotification(event.data.name, event.data.formatname);
    }
});

window.addEventListener('keydown', function (event) {
    console.log(event.key)
    if (event.key == 'Escape' || event.key == 'k' || event.key == 'Tab') {
        if (self.DEVELOPER == false) {
            self.opened = false;
        }
        else {
            self.opened = !self.opened;
        }
    }
});