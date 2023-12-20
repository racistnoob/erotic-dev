const TranslationSelected = 'en';
const Translations = {}

Translations['en'] = {
    'settings': 'Settings',
    'main_inventory': ' ',
    'weight_measure': 'lbs',
    'throw': 'Drop',
    'use': 'Use',
    'give': 'Give',
    'settings_sfx': 'Sounds',
    'settings_charactername': 'Character name',
    'settings_background': 'Background',
    'settings_blur': 'Blur',
    'settings_itemdescription': 'Item description',
    'settings_itemnames': 'Item names',
    'settings_slots': 'Slot indications',
    'settings_itembg_1': 'Items background (1)',
    'settings_itembg_2': 'Items background (2)',
    'reset': 'Default settings',
    'settings_weightbg_1': 'Weight background',
    'settings_weightbg_2': 'Weight fill color',
    'nearby_players': 'Nearby players'
}

Translations['hu'] = {
    'settings': 'Beállítások',
    'main_inventory': 'Leltár',
    'weight_measure': 'kg.',
    'throw': 'Eldob',
    'use': 'Használ',
    'give': 'Átad',
    'settings_sfx': 'Hangok',
    'settings_charactername': 'Karakternév',
    'settings_background': 'Háttér',
    'settings_blur': 'Elmosódás',
    'settings_itemdescription': 'Tárgyak leírása',
    'settings_itemnames': 'Tárgyak nevei',
    'settings_slots': 'Slotok jelzése',
    'settings_itembg_1': 'Tárgyak háttere (1)',
    'settings_itembg_2': 'Tárgyak háttere (2)',
    'reset': 'Gyári beállítások',
    'settings_weightbg_1': 'Súly háttere',
    'settings_weightbg_2': 'Súly kitöltés színe',
    'nearby_players': 'Közeli játékosok'
}

function _U(a) {
    if (Translations[TranslationSelected] && Translations[TranslationSelected][a]) {
        return Translations[TranslationSelected][a];
    }
    else return 'Translation not found..';
}