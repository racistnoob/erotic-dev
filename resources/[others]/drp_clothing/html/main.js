$(function() {


    $(".header-option").click(function() {
        const selectedOption = $(this).html()
        if (selectedOption == "Clothes") {
            if ($(".clothing-tab").css("display") == "none") {
                $(".accessories-tab").fadeOut(0)
                $(".character-tab").fadeOut(0)
                $(".clothing-tab").fadeIn(0)
            }
        } else if (selectedOption == "Accessories") {
            if ($(".accessories-tab").css("display") == "none") {
                $(".clothing-tab").fadeOut(0)
                $(".character-tab").fadeOut(0)
                $(".accessories-tab").fadeIn(0)
            }
        } else if (selectedOption == "Character") {
            if ($(".character-tab").css("display") == "none") {
                $(".clothing-tab").fadeOut(0)
                $(".accessories-tab").fadeOut(0)
                $(".character-tab").fadeIn(0)
            }
        } else if (selectedOption == "Parents") {
            if ($(".parents-tab").css("display") == "none") {
                $(".face-tab").fadeOut(0)
                $(".skin-tab").fadeOut(0)
                $(".hair-tab").fadeOut(0)
                $(".makeup-tab").fadeOut(0)
                $(".parents-tab").fadeIn(0)
            }
        } else if (selectedOption == "Face") {
            if ($(".face-tab").css("display") == "none") {
                $(".parents-tab").fadeOut(0)
                $(".skin-tab").fadeOut(0)
                $(".hair-tab").fadeOut(0)
                $(".makeup-tab").fadeOut(0)
                $(".face-tab").fadeIn(0)
            }
        } else if (selectedOption == "Skin") {
            if ($(".skin-tab").css("display") == "none") {
                $(".parents-tab").fadeOut(0)
                $(".face-tab").fadeOut(0)
                $(".hair-tab").fadeOut(0)
                $(".makeup-tab").fadeOut(0)
                $(".skin-tab").fadeIn(0)
            }
        } else if (selectedOption == "Hair") {
            if ($(".hair-tab").css("display") == "none") {
                $(".parents-tab").fadeOut(0)
                $(".face-tab").fadeOut(0)
                $(".skin-tab").fadeOut(0)
                $(".makeup-tab").fadeOut(0)
                $(".hair-tab").fadeIn(0)
            }
        } else if (selectedOption == "Makeup") {
            if ($(".makeup-tab").css("display") == "none") {
                $(".parents-tab").fadeOut(0)
                $(".face-tab").fadeOut(0)
                $(".skin-tab").fadeOut(0)
                $(".hair-tab").fadeOut(0)
                $(".makeup-tab").fadeIn(0)
            }
        }
    })

    function SliderMoved(info) {
        const Option = info.attr("id")
        if (Option == "shapeFirst" || Option == "shapeSecond" || Option == "shapeThird" || Option == "skinFirst" || Option == "skinSecond" || Option == "skinThird" || Option == "shapeMix" || Option == "skinMix" || Option == "thirdMix") {
            headBlend = {}
            headBlend["shapeFirst"] = $("span").filter("[data-option='shapeFirst']").filter("[data-type='item']").html()
            headBlend["shapeSecond"] = $("span").filter("[data-option='shapeSecond']").filter("[data-type='item']").html()
            headBlend["shapeThird"] = $("span").filter("[data-option='shapeThird']").filter("[data-type='item']").html()
            headBlend["skinFirst"] = $("span").filter("[data-option='skinFirst']").filter("[data-type='option']").html()
            headBlend["skinSecond"] = $("span").filter("[data-option='skinSecond']").filter("[data-type='option']").html()
            headBlend["skinThird"] = $("span").filter("[data-option='skinThird']").filter("[data-type='option']").html()
            headBlend["shapeMix"] = $("#shapeMix").val()
            headBlend["skinMix"] = $("#skinMix").val()
            headBlend["thirdMix"] = $("#thirdMix").val()
            $.post('https://drp_clothing/saveheadblend', JSON.stringify(headBlend))
        } else if (Option == "Nose_Width" || Option == "Nose_Peak_Hight" || Option == "Nose_Peak_Lenght" || Option == "Nose_Bone_High" || Option == "Nose_Peak_Lowering" || Option == "Nose_Bone_Twist" || Option == "EyeBrown_High" || Option == "EyeBrown_Forward" || Option == "Cheeks_Bone_High" || Option == "Cheeks_Bone_Width" || Option == "Cheeks_Width" || Option == "Jaw_Bone_Width" || Option == "Jaw_Bone_Back_Lenght" || Option == "Chimp_Bone_Lowering" || Option == "Chimp_Bone_Lenght" || Option == "Chimp_Bone_Width" || Option == "Chimp_Hole" || Option == "Eyes_Openning" || Option == "Lips_Thickness" || Option == "Neck_Thikness") {
            $.post('https://drp_clothing/savefacefeatures', JSON.stringify({ name: Option, scale: info.val() }))
        } else if (Option == "Blemishesopacity" || Option == "Ageingopacity" || Option == "Makeupopacity" || Option == "Complexionopacity" || Option == "SunDamageopacity" || Option == "MolesFrecklesopacity" || Option == "BodyBlemishesopacity" || Option == "FacialHairopacity" || Option == "Blushopacity" || Option == "Lipstickopacity" || Option == "Eyebrowsopacity" || Option == "ChestHairopacity") {
            $.post('https://drp_clothing/saveheadoverlay', JSON.stringify({
                name: info.data("option"),
                value: $("span").filter("[data-option='" + info.data("option") + "']").filter("[data-type='item']").html(),
                opacity: info.val()
            }))
        } else {}
    }

    $('.slider').on('input', function() { SliderMoved($(this)) })
    $('.slider-half').on('input', function() { SliderMoved($(this)) })

    const InputKeys = [87, 83, 119, 115]
    const KeyUpKeys = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 46, 8, 96, 98, 99, 101, 102, 103, 104, 105]

    $(".option-input").keyup(function(e) {
        if (KeyUpKeys.includes(e.keyCode)) {
            var thisOption = $(this).data("option")
            var thisType = $(this).data('type')
            if (thisOption) {
                const thisOptionInfo = $("input").filter("[data-option='" + thisOption + "']")
                const thisCurr = $(this).text()

                var NewVal = thisCurr

                var Texture = 0
                var Item = 0

                if (thisType == "item") {
                    Texture = thisOptionInfo.filter("[data-type='option']").html()
                } else if (thisType == "option") {
                    Item = thisOptionInfo.filter("[data-type='item']").html()
                }

                if (thisType == "option") { Texture = NewVal }
                if (thisType == "item") { Item = NewVal }

                if (thisType == "item") {
                    ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
                } else if (thisType == "option") {
                    ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='item']"), "skin_female")
                }
            }
        } else {
            if (e.keyCode == 13) { $(this).blur() }
            e.preventDefault();
        }
    })

    $('.option-input').keypress(function(e) {
        if (InputKeys.includes(e.keyCode)) {
            e.preventDefault()
            var thisOption = $(this).data("option")
            var thisType = $(this).data('type')
            if (e.keyCode == 119 || e.keyCode == 87) {
                if ($(this).data("option")) { thisOption = $(this).data("option") }
                if (thisOption) {
                    const thisOptionInfo = $("span").filter("[data-option='" + thisOption + "']")
                    const something = thisOptionInfo.filter("[data-type='" + thisType + "']")
                    const something2 = $(".item-option-option").filter("[data-option='" + thisOption + "']").filter("[data-type='" + thisType + "']")
                    const thisMax = something2.data("max")
                    const thisCurr = something.html()

                    var NewVal = Number(thisCurr) + 1

                    var Texture = 0
                    var Item = 0

                    if (thisType == "item") {
                        Texture = thisOptionInfo.filter("[data-type='option']").html()
                    } else if (thisType == "option") {
                        Item = thisOptionInfo.filter("[data-type='item']").html()
                    }


                    if (NewVal < 0) {
                        NewVal = thisMax
                    }

                    if (NewVal > thisMax) {
                        NewVal = -1
                    }

                    something.data("current", NewVal)
                    something.html(NewVal)

                    if (thisType == "option") { Texture = NewVal }
                    if (thisType == "item") { Item = NewVal }

                    if (thisType == "item") {
                        ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
                    } else if (thisType == "option") {
                        ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='item']"), "skin_female")
                    }
                }

            } else if (e.keyCode == 115 || e.keyCode == 83) {
                if ($(this).data("option")) { thisOption = $(this).data("option") }
                if (thisOption) {
                    const thisOptionInfo = $("span").filter("[data-option='" + thisOption + "']")
                    const something = thisOptionInfo.filter("[data-type='" + thisType + "']")
                    const something2 = $(".item-option-option").filter("[data-option='" + thisOption + "']").filter("[data-type='" + thisType + "']")
                    const thisMax = something2.data("max")
                    const thisCurr = something.html()

                    var NewVal = Number(thisCurr) - 1

                    var Texture = 0
                    var Item = 0

                    if (thisType == "item") {
                        Texture = thisOptionInfo.filter("[data-type='option']").html()
                    } else if (thisType == "option") {
                        Item = thisOptionInfo.filter("[data-type='item']").html()
                    }

                    if (NewVal < -1) {
                        NewVal = thisMax
                    }

                    if (NewVal > thisMax) {
                        NewVal = -1
                    }

                    something.data("current", NewVal)
                    something.html(NewVal)

                    if (thisType == "option") { Texture = NewVal }
                    if (thisType == "item") { Item = NewVal }

                    if (thisType == "item") {
                        ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
                    } else if (thisType == "option") {
                        ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='item']"), "skin_female")
                    }
                }
            }
        } else {
            if (KeyUpKeys.includes(e.keyCode) == true) {
                // Do nothing
            } else {
                e.preventDefault()
            }
        }
    });

    $(".item-arrow-left").click(function() {
        var thisOption = $(this).parent().parent().parent().parent().data('option')
        if ($(this).data("option")) { thisOption = $(this).data("option") }
        const thisType = $(this).data('type')
        if (thisOption) {
            const thisOptionInfo = $("span").filter("[data-option='" + thisOption + "']")
            const something = thisOptionInfo.filter("[data-type='" + thisType + "']")
            const something2 = $(".item-option-option").filter("[data-option='" + thisOption + "']").filter("[data-type='" + thisType + "']")
            const thisMax = something2.data("max")
            const thisCurr = something.html()

            var NewVal = Number(thisCurr) - 1

            var Texture = 0
            var Item = 0

            if (thisType == "item") {
                Texture = thisOptionInfo.filter("[data-type='option']").html()
            } else if (thisType == "option") {
                Item = thisOptionInfo.filter("[data-type='item']").html()
            }

            if (NewVal < -1) {
                NewVal = thisMax
            }

            if (NewVal > thisMax) {
                NewVal = -1
            }

            something.data("current", NewVal)
            something.html(NewVal)

            if (thisType == "option") { Texture = NewVal }
            if (thisType == "item") { Item = NewVal }

            if (thisOption == "skins-male") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
            } else if (thisOption == "skins-female") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_female")
            } else if (thisType == "item") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
            } else if (thisType == "option") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='item']"), "skin_female")
            }
        }
    });

    $(".eye-color-option").click(function() {
        if ($(this).parent().hasClass("eye-color-options")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveeyecolor', JSON.stringify({
                "firstColour": ColorIndex,
            }))
        }
    })

    $(".hair-color-option").click(function() {
        if ($(this).parent().hasClass("hair-color-options-primary")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/savehaircolor', JSON.stringify({ "firstColour": ColorIndex, }))
        } else if ($(this).parent().hasClass("hair-color-options-secondary")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/savehaircolor', JSON.stringify({ "secondColour": ColorIndex, }))
        } else if ($(this).parent().hasClass("hair-color-options-facialhair")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "FacialHair", "firstColour": ColorIndex }))
        } else if ($(this).parent().hasClass("hair-color-options-Blush")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "Blush", "firstColour": ColorIndex }))
        } else if ($(this).parent().hasClass("hair-color-options-Lipstick")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "Lipstick", "firstColour": ColorIndex }))
        } else if ($(this).parent().hasClass("hair-color-options-Eyebrows")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "Eyebrows", "firstColour": ColorIndex }))
        } else if ($(this).parent().hasClass("hair-color-options-ChestHair")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "ChestHair", "firstColour": ColorIndex }))
        } else if ($(this).parent().hasClass("hair-color-options-Makeup-primary")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "Makeup", "firstColour": ColorIndex }))
        } else if ($(this).parent().hasClass("hair-color-options-Makeup-secondary")) {
            const ColorIndex = $(this).data("index")
            $.post('https://drp_clothing/saveheadoverlaycolor', JSON.stringify({ "name": "Makeup", "secondColour": ColorIndex }))
        }
    })

    $(".item-arrow-right").click(function() {
        var thisOption = $(this).parent().parent().parent().parent().data('option')
        if ($(this).data("option")) { thisOption = $(this).data("option") }
        const thisType = $(this).data('type')
        if (thisOption) {
            const thisOptionInfo = $("span").filter("[data-option='" + thisOption + "']")
            const something = thisOptionInfo.filter("[data-type='" + thisType + "']")
            const something2 = $(".item-option-option").filter("[data-option='" + thisOption + "']").filter("[data-type='" + thisType + "']")
            const thisMax = something2.data("max")
            const thisCurr = something.html()

            var NewVal = Number(thisCurr) + 1

            var Texture = 0
            var Item = 0

            if (thisType == "item") {
                Texture = thisOptionInfo.filter("[data-type='option']").html()
            } else if (thisType == "option") {
                Item = thisOptionInfo.filter("[data-type='item']").html()
            }


            if (NewVal < 0) {
                NewVal = thisMax
            }

            if (NewVal > thisMax) {
                NewVal = -1
            }

            something.data("current", NewVal)
            something.html(NewVal)

            if (thisType == "option") { Texture = NewVal }
            if (thisType == "item") { Item = NewVal }

            if (thisOption == "skins-male") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
            } else if (thisOption == "skins-female") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_female")
            } else if (thisType == "item") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='option']"), "skin_male")
            } else if (thisType == "option") {
                ArrowClicked(NewVal, thisOption, thisType, Texture, Item, thisOptionInfo.filter("[data-type='item']"), "skin_female")
            }
        }
    });

    // Tattoo Options

    $(".item-plus").click(function() {
        const Type = $(this).parent().parent().data("option")
        const Item = $("span").filter("[data-option='" + Type + "']").filter("[data-type='item']").html()
        $.post('https://drp_clothing/addtat', JSON.stringify({
            "name": Type,
            "value": Item,
        }))
    })

    $(".item-negative").click(function() {
        const Type = $(this).parent().parent().data("option")
        const Item = $("span").filter("[data-option='" + Type + "']").filter("[data-type='item']").html()
        $.post('https://drp_clothing/removetat', JSON.stringify({
            "name": Type,
            "value": Item,
        }))
    })

    $(".item-clear").click(function() {
        const Type = $(this).parent().parent().data("option")
        $.post('https://drp_clothing/clearcategtats', JSON.stringify({
            "name": Type,
        }))
    })

    $(".option-header").click(function() {
        const ClassName = $(this).data("childcolors")
        if (ClassName) {
            const CurrState = $(`.${ClassName}`).data("hidden")
            if (CurrState == true || CurrState == "true") {
                $(`.${ClassName}`).css("height", "100%")
                $(`.${ClassName}`).data("hidden", "false")
            } else {
                $(`.${ClassName}`).css("height", "3.5vh")
                $(`.${ClassName}`).data("hidden", "true")
            }
        }
    })

    $(".item-middle-option").click(function() {
        const Icon = $(this).children().attr('class');
        if (Icon == "fas fa-hat-cowboy") {
            $.post('https://drp_clothing/toggleclothes', JSON.stringify({ "name": "hats" }))
        } else if (Icon == "fas fa-tshirt") {
            $.post('https://drp_clothing/toggleclothes', JSON.stringify({ "name": "shirts" }))
        } else if (Icon == "fas fa-user-secret") {
            $.post('https://drp_clothing/toggleclothes', JSON.stringify({ "name": "jackets" }))
        } else if (Icon == "fas fa-user-tie item-shirt") {
            $.post('https://drp_clothing/switchcam', JSON.stringify({ "name": "torso" }))
        } else if (Icon == "fas fa-smile-wink") {
            $.post('https://drp_clothing/switchcam', JSON.stringify({ "name": "head" }))
        } else if (Icon == "fas fa-theater-masks") {
            $.post('https://drp_clothing/toggleclothes', JSON.stringify({ "name": "masks" }))
        } else if (Icon == "fas fa-glasses") {
            $.post('https://drp_clothing/toggleclothes', JSON.stringify({ "name": "glasses" }))
        } else if (Icon == "fas fa-socks") {
            $.post('https://drp_clothing/switchcam', JSON.stringify({ "name": "leg" }))
        }
    })

    function ArrowClicked(NewVal, Option, Type, Texture, Item, s, edited) {
        if (Option == "skins-male" || Option == "skins-female" || Option == "gender") {
            $.post('https://drp_clothing/setped', JSON.stringify({
                "name": edited,
                "value": NewVal
            }))
        } else if (Option == "Blemishes" || Option == "Ageing" || Option == "Complexion" || Option == "SunDamage" || Option == "MolesFreckles" || Option == "BodyBlemishes" || Option == "FacialHair" || Option == "Blush" || Option == "Lipstick" || Option == "ChestHair" || Option == "Eyebrows" || Option == "Makeup") {
            $.post('https://drp_clothing/saveheadoverlay', JSON.stringify({
                name: Option,
                value: NewVal,
                opacity: $(`#${Option}opacity`).val()
            }))
        } else if (Option == "shapeFirst" || Option == "shapeSecond" || Option == "shapeThird" || Option == "skinFirst" || Option == "skinSecond" || Option == "skinThird" || Option == "shapeMix" || Option == "skinMix" || Option == "thirdMix") {
            headBlend = {}
            headBlend["shapeFirst"] = $("span").filter("[data-option='shapeFirst']").filter("[data-type='item']").html()
            headBlend["shapeSecond"] = $("span").filter("[data-option='shapeSecond']").filter("[data-type='item']").html()
            headBlend["shapeThird"] = $("span").filter("[data-option='shapeThird']").filter("[data-type='item']").html()
            headBlend["skinFirst"] = $("span").filter("[data-option='skinFirst']").filter("[data-type='option']").html()
            headBlend["skinSecond"] = $("span").filter("[data-option='skinSecond']").filter("[data-type='option']").html()
            headBlend["skinThird"] = $("span").filter("[data-option='skinThird']").filter("[data-type='option']").html()
            headBlend["shapeMix"] = $("#shapeMix").val()
            headBlend["skinMix"] = $("#skinMix").val()
            headBlend["thirdMix"] = $("#thirdMix").val()
            $.post('https://drp_clothing/saveheadblend', JSON.stringify(headBlend))
        } else if (Option == "ZONE_TORSO" || Option == "ZONE_HEAD" || Option == "ZONE_LEFT_ARM" || Option == "ZONE_RIGHT_ARM" || Option == "ZONE_LEFT_LEG" || Option == "ZONE_RIGHT_LEG") {
            $.post('https://drp_clothing/previewtat', JSON.stringify({
                "name": Option,
                "value": Item,
            }))
        } else {
            if (Type == "item") {
                $.post('https://drp_clothing/updateclothes', JSON.stringify({
                    "name": Option,
                    "value": Item,
                    "texture": Texture
                })).done(function(data) {
                    $(".item-option-option").filter("[data-option='" + Option + "']").filter("[data-type='option']").data("max", data)
                    $(".item-option-option").filter("[data-option='" + Option + "']").filter("[data-type='option']").data("current", 0)
                    $(".item-option-option").filter("[data-option='" + Option + "']").filter("[data-type='option']").html(`/${data}`)
                    s.html(0)
                });
            } else if (Type == "option") {
                $.post('https://drp_clothing/updateclothes', JSON.stringify({
                    "name": Option,
                    "value": Item,
                    "texture": Texture
                }));
            }
        }

    }

    function CloseMenu(save) {
        $.post('https://drp_clothing/escape', JSON.stringify({
            save: save
        }));
    }

    $(".footer-option-save").click(function() {
        CloseMenu(true)
    })

    /*
    $(".footer-option-discard").click(function() {
        CloseMenu(false)
    }) */

    window.addEventListener('message', function(event) {
        let e = event.data;
        if (e.type == "totalData") {

            const drawTotal = e.drawTotal
            for (var item in drawTotal) { // Clothing Menu
                const type = drawTotal[item][0]
                const max = drawTotal[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", max)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").prop("max", max)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", max)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").html(`/${max}`)
            }

            const propDrawTotal = e.propDrawTotal
            for (var item in propDrawTotal) { // Clothing Menu
                const type = propDrawTotal[item][0]
                const max = propDrawTotal[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", max)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").prop("max", max)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", max)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").html(`/${max}`)
            }

            const textureTotal = e.textureTotal

            for (var i in textureTotal) {
                const type = i
                const max = textureTotal[i]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").data("max", max)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").prop("max", max)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='option']").data("max", max)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='option']").html(`/${max}`)
            }

            const headoverlayTotal = e.headoverlayTotal
            for (var i in headoverlayTotal) {
                const type = i
                const value = headoverlayTotal[i]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").prop("max", value)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
                $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").html(`/${value}`)
            }

            const skinTotal = e.skinTotal

            var type = "skins-male"
            var value = skinTotal[0]
            $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
            $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").prop("max", value)
            $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
            $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").html(`/${value}`)

            var type = "skins-female"
            var value = skinTotal[1]
            $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
            $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").prop("max", value)
            $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
            $(".item-option-option").filter("[data-option='" + type + "']").filter("[data-type='item']").html(`/${value}`)

        } else if (e.type == "clothingData") {

            const drawables = e.drawables
            for (var item in drawables) {
                const type = drawables[item][0]
                const currentvalue = drawables[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("current", currentvalue)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").html(currentvalue)
            }

            const props = e.props
            for (var item in props) {
                const type = props[item][0]
                const currentvalue = props[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("current", currentvalue)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").html(currentvalue)
            }

            const drawtextures = e.drawtextures
            for (var item in drawtextures) {
                const type = drawtextures[item][0]
                const currentvalue = drawtextures[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").data("current", currentvalue)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").html(currentvalue)
            }

            const proptextures = e.proptextures
            for (var item in proptextures) {
                const type = proptextures[item][0]
                const currentvalue = proptextures[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").data("current", currentvalue)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").html(currentvalue)
            }

            /**const skin = e.drawables
            for (var item in skin) {
            	const type = skin[item][0]
            	const currentvalue = skin[item][1]
            	$("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("current", currentvalue)
            	$("span").filter("[data-option='" + type + "']").filter("[data-type='item']").html(currentvalue)
            }*/

            const skin = e.skin
            if (skin['name'] == "skin_male") {
                var type = "skins-male"
                var currentvalue = skin['value']
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("current", currentvalue)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").html(currentvalue)

                var othertype = "skins-female"
                var currentvalue = 0
                $("span").filter("[data-option='" + othertype + "']").filter("[data-type='item']").data("current", currentvalue)
                $("span").filter("[data-option='" + othertype + "']").filter("[data-type='item']").html(currentvalue)
            } else if (skin['name'] == "skin_female") {
                var type = "skins-female"
                var currentvalue = skin['value']
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("current", currentvalue)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").html(currentvalue)

                var othertype = "skins-male"
                var currentvalue = 0
                $("span").filter("[data-option='" + othertype + "']").filter("[data-type='item']").data("current", currentvalue)
                $("span").filter("[data-option='" + othertype + "']").filter("[data-type='item']").html(currentvalue)
            }

        } else if (e.type == "enableClothing") {
            const Enable = event.data.enable;
            const Menu = event.data.menu
            if (Menu) {
                if (Menu == "Clothing") {
                    $(".Barber-Menu").fadeOut(0)
                    $(".Tattoo-Menu").fadeOut(0)
                    $(".Clothing-Menu").fadeIn(250)
                } else if (Menu == "Barber") {
                    $(`.Barber-Menu`).fadeIn(0)
                    $(".Clothing-Menu").fadeOut(0)
                    $(".Tattoo-Menu").fadeOut(0)
                } else if (Menu == "Tattoo") {
                    $(`.Tattoo-Menu`).fadeIn(0)
                    $(".Clothing-Menu").fadeOut(0)
                    $(".Barber-Menu").fadeOut(0)
                }

                // to do
            }
            if (Enable) {
                $("body").fadeIn(250)
            } else if (Enable == false) {
                $("body").fadeOut(250)
            }
        } else if (e.type == "barberData") {

            const headBlend = e.headBlend
            for (var i in headBlend) {
                const type = i
                const value = headBlend[i]

                if (type == "shapeFirst" || type == "shapeSecond" || type == "shapeThird") {
                    $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("current", value)
                    $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").html(value)
                } else if (type == "skinFirst" || type == "skinSecond" || type == "skinThird") {
                    $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").data("current", value)
                    $("span").filter("[data-option='" + type + "']").filter("[data-type='option']").html(value)
                } else if (type == "skinMix" || type == "shapeMix" || type == "thirdMix") {
                    $(`#${type}`).val(headBlend[i] * 100)
                }
            }

            const headOverlay = e.headOverlay
            for (var i in headOverlay) {
                const Name = headOverlay[i]['name']
                const Value = headOverlay[i]['overlayValue']
                const Opacity = headOverlay[i]['overlayOpacity']
                $("span").filter("[data-option='" + Name + "']").filter("[data-type='item']").data("current", Value)
                $("span").filter("[data-option='" + Name + "']").filter("[data-type='item']").html(Value)
                $(`#${Name}opacity`).val(Opacity * 100)
            }

            const headStructure = e.headStructure
            for (var i in headStructure) {
                $(`#${i}`).val(headStructure[i] * 100)
            }
        } else if (e.type == "tattooData") {
            const tatCategory = e.tatCategory
            const tats = e.tats

            for (var item in tatCategory) {
                const type = tatCategory[item][0]
                const value = tatCategory[item][1]
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").data("max", value)
                $("span").filter("[data-option='" + type + "']").filter("[data-type='item']").attr("max", value)
            }

        } else {}
    })

});