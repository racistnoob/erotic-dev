(this.webpackJsonpweb = this.webpackJsonpweb || []).push([
    [0], {
        129: function(e, t, a) {},
        139: function(e, t, a) {
            "use strict";
            a.r(t);
            var c = a(0),
                n = a.n(c),
                r = a(38),
                i = a.n(r),
                s = (a(129), a(7)),
                l = (a(89), a(1));
            var o = function(e) {
                    return Object(l.jsxs)("div", {
                        className: "characterItem ".concat(e.current === e.value.id ? "active" : ""),
                        onClick: function() {
                            e.value.KEK, e.setCharacter(e.value)
                        },
                        children: [Object(l.jsx)("div", {
                            className: "characterId",
                            children: e.value.id
                        }), Object(l.jsxs)("div", {
                            className: "characterName",
                            children: [e.value.firstname, " ", e.value.lastname]
                        })]
                    })
                },
                d = a(93),
                j = a(213),
                u = a(204),
                h = a(106),
                b = a(200),
                O = a(214),
                x = a(192),
                m = a(205),
                f = a(216),
                v = a(201),
                p = a(210),
                g = a(100),
                C = a(206),
                N = a(196),
                y = a(198),
                w = a(199),
                S = a(83),
                I = a.n(S),
                k = a(94);

            function K(e, t) {
                return E.apply(this, arguments)
            }

            function E() {
                return (E = Object(k.a)(I.a.mark((function e(t, a) {
                    var c, n, r, i;
                    return I.a.wrap((function(e) {
                        for (;;) switch (e.prev = e.next) {
                            case 0:
                                return c = {
                                    method: "post",
                                    headers: {
                                        "Content-Type": "application/json; charset=UTF-8"
                                    },
                                    body: JSON.stringify(a)
                                }, n = window.GetParentResourceName ? window.GetParentResourceName() : "nui-frame-app", e.next = 4, fetch("https://".concat(n, "/").concat(t), c);
                            case 4:
                                return r = e.sent, e.next = 7, r.json();
                            case 7:
                                return i = e.sent, e.abrupt("return", i);
                            case 9:
                            case "end":
                                return e.stop()
                        }
                    }), e)
                })))).apply(this, arguments)
            }
            var D = a(98),
                T = a.n(D),
                B = a(203),
                L = function(e) {
                    var t = n.a.useState(!0),
                        a = Object(s.a)(t, 2),
                        c = a[0],
                        r = (a[1], n.a.useState("")),
                        i = Object(s.a)(r, 2),
                        o = i[0],
                        S = i[1],
                        I = n.a.useState(""),
                        k = Object(s.a)(I, 2),
                        E = k[0],
                        D = k[1],
                        L = n.a.useState("m"),
                        F = Object(s.a)(L, 2),
                        U = F[0],
                        A = F[1],
                        P = n.a.useState(""),
                        R = Object(s.a)(P, 2),
                        G = R[0],
                        Y = R[1],
                        M = n.a.useState(null),
                        J = Object(s.a)(M, 2),
                        q = J[0],
                        H = J[1];

                    function $(e) {
                        console.log(e.target.value), A(e.target.value)
                    }
                    var _ = Object(g.a)({
                            palette: {
                                mode: c ? "dark" : "light"
                            }
                        }),
                        z = n.a.useState(!1),
                        V = Object(s.a)(z, 2),
                        W = V[0],
                        Q = V[1];
                    var X = function(e, t) {
                        "clickaway" !== t && Q(!1)
                    };
                    return Object(l.jsxs)("div", {
                        className: "CUI",
                        style: {
                            display: e.isCreating ? "" : "none"
                        },
                        children: [Object(l.jsx)(B.a, {
                            anchorOrigin: {
                                vertical: "top",
                                horizontal: "center"
                            },
                            open: W,
                            autoHideDuration: 2500,
                            onClose: X,
                            message: G,
                            action: Object(l.jsx)(n.a.Fragment, {
                                children: Object(l.jsx)(j.a, {
                                    color: "primary",
                                    onClick: X,
                                    children: Object(l.jsx)(T.a, {})
                                })
                            })
                        }), Object(l.jsx)(C.a, {
                            theme: _,
                            children: Object(l.jsx)(u.a, {
                                children: Object(l.jsx)(h.a, {
                                    elevation: 5,
                                    style: {
                                        paddingBottom: 10,
                                        paddingTop: 10,
                                        paddingLeft: 20,
                                        paddingRight: 20,
                                        height: "395px",
                                        width: 280,
                                        margin: "auto"
                                    },
                                    children: Object(l.jsxs)(u.a, {
                                        container: !0,
                                        direction: "column",
                                        children: [Object(l.jsx)("h2", {
                                            children: "Create Character"
                                        }), Object(l.jsxs)(u.a, {
                                            container: !0,
                                            direction: "column",
                                            rowSpacing: 1,
                                            children: [Object(l.jsx)(u.a, {
                                                item: !0,
                                                children: Object(l.jsx)(b.a, {
                                                    onChange: function(e) {
                                                        S(e.target.value), console.log(e.target.value)
                                                    },
                                                    label: "First Name",
                                                    placeholder: "Mihai",
                                                    required: !0,
                                                    sx: {
                                                        width: 1
                                                    }
                                                })
                                            }), Object(l.jsx)(u.a, {
                                                item: !0,
                                                children: Object(l.jsx)(b.a, {
                                                    onChange: function(e) {
                                                        D(e.target.value)
                                                    },
                                                    label: "Last Name",
                                                    placeholder: "Snow",
                                                    required: !0,
                                                    sx: {
                                                        width: 1
                                                    }
                                                })
                                            }), Object(l.jsx)(u.a, {
                                                item: !0,
                                                sx: {
                                                    width: 1
                                                },
                                                children: Object(l.jsx)(N.b, {
                                                    dateAdapter: w.a,
                                                    children: Object(l.jsx)("div", {
                                                        className: "customDatePickerWidth",
                                                        children: Object(l.jsx)(y.a, {
                                                            label: "Date of Birth",
                                                            value: q,
                                                            onChange: function(e) {
                                                                H(e)
                                                            },
                                                            renderInput: function(e) {
                                                                return Object(l.jsx)(b.a, Object(d.a)({}, e))
                                                            }
                                                        })
                                                    })
                                                })
                                            }), Object(l.jsx)(u.a, {
                                                item: !0,
                                                children: Object(l.jsxs)(O.a, {
                                                    component: "fieldset",
                                                    children: [Object(l.jsx)(x.a, {
                                                        component: "legend",
                                                        children: "Gender"
                                                    }), Object(l.jsxs)(m.a, {
                                                        row: !0,
                                                        "aria-label": "gender",
                                                        name: "row-radio-buttons-group",
                                                        children: [Object(l.jsx)(f.a, {
                                                            onChange: $,
                                                            value: "m",
                                                            control: Object(l.jsx)(v.a, {}),
                                                            label: "Male"
                                                        }), Object(l.jsx)(f.a, {
                                                            onChange: $,
                                                            value: "f",
                                                            control: Object(l.jsx)(v.a, {}),
                                                            label: "Female"
                                                        }), Object(l.jsx)(f.a, {
                                                            onChange: $,
                                                            value: "other",
                                                            control: Object(l.jsx)(v.a, {}),
                                                            label: "Other"
                                                        })]
                                                    })]
                                                })
                                            }), Object(l.jsxs)(u.a, {
                                                container: !0,
                                                direction: "row",
                                                columnSpacing: 1,
                                                sx: {
                                                    mt: 1
                                                },
                                                children: [Object(l.jsx)(u.a, {
                                                    item: !0,
                                                    children: Object(l.jsx)(p.a, {
                                                        variant: "contained",
                                                        onClick: function() {
                                                            return o && "" !== o ? E && "" !== E ? U && "" !== U ? q ? void K("createNewCharacter", {
                                                                firstname: o,
                                                                lastname: E,
                                                                gender: U,
                                                                dob: new Date(q).toISOString().split("T")[0]
                                                            }).then((function(t) {
                                                                e.tUI(!1)
                                                            })) : (Y("You must select a date of birth"), void Q(!0)) : (Y("You must select a gender"), void Q(!0)) : (Y("You must input a last name"), void Q(!0)) : (Y("You must input a first name"), void Q(!0))
                                                        },
                                                        children: " Create "
                                                    })
                                                }), Object(l.jsx)(u.a, {
                                                    item: !0,
                                                    children: Object(l.jsx)(p.a, {
                                                        variant: "contained",
                                                        onClick: function() {
                                                            e.tUI(!1)
                                                        },
                                                        children: " Cancel "
                                                    })
                                                })]
                                            })]
                                        })]
                                    })
                                })
                            })
                        })]
                    })
                },
                F = a(197),
                U = a(209),
                A = a(208),
                P = a(212),
                R = a(211),
                G = Object(g.a)({
                    palette: {
                        mode: "dark"
                    }
                });

            function Y(e) {
                var t = c.useState(!1),
                    a = Object(s.a)(t, 2),
                    n = (a[0], a[1], function() {
                        e.tUI(!1)
                    });
                return Object(l.jsx)("div", {
                    children: Object(l.jsx)(C.a, {
                        theme: G,
                        children: Object(l.jsxs)(F.a, {
                            open: e.isDeleting,
                            onClose: n,
                            "aria-labelledby": "alert-dialog-title",
                            "aria-describedby": "alert-dialog-description",
                            children: [Object(l.jsx)(R.a, {
                                id: "alert-dialog-title",
                                children: "Delete Character?"
                            }), Object(l.jsx)(A.a, {
                                children: Object(l.jsx)(P.a, {
                                    id: "alert-dialog-description",
                                    children: "Are you sure you want to delete your character? This action in irreversible!"
                                })
                            }), Object(l.jsxs)(U.a, {
                                children: [Object(l.jsx)(p.a, {
                                    onClick: n,
                                    children: "No"
                                }), Object(l.jsx)(p.a, {
                                    onClick: function() {
                                        e.deleteCharacter()
                                    },
                                    autoFocus: !0,
                                    children: "Yes"
                                })]
                            })]
                        })
                    })
                })
            }
            var M = function() {},
                J = function(e, t) {
                    var a = Object(c.useRef)(M);
                    Object(c.useEffect)((function() {
                        a.current = t
                    }), [t]), Object(c.useEffect)((function() {
                        var t = function(t) {
                            var c = t.data,
                                n = c.action,
                                r = c.data;
                            a.current && n === e && a.current(r)
                        };
                        return window.addEventListener("message", t),
                            function() {
                                return window.removeEventListener("message", t)
                            }
                    }), [e])
                },
                q = a(71),
                H = function() {
                    var e = Object(c.useState)([]),
                        t = Object(s.a)(e, 2),
                        a = t[0],
                        n = t[1],
                        r = Object(c.useState)(Object),
                        i = Object(s.a)(r, 2),
                        d = i[0],
                        j = i[1],
                        u = Object(c.useState)(!1),
                        h = Object(s.a)(u, 2),
                        b = h[0],
                        O = h[1],
                        x = Object(c.useState)(!1),
                        m = Object(s.a)(x, 2),
                        f = m[0],
                        v = m[1],
                        p = Object(c.useState)(!1),
                        g = Object(s.a)(p, 2),
                        C = g[0],
                        N = g[1],
                        y = Object(c.useState)(!1),
                        w = Object(s.a)(y, 2),
                        S = w[0],
                        I = w[1];

                    function k(e) {
                        j(e), 0 !== e.KEK || e.KEK ? (O(!0), K("cDataPed", e).then((function(e) {}))) : O(!1)
                    }

                    function E() {
                        N(!1), I(!1)
                    }
                    return J("toggleVisiblity", (function(e) {
                        v(e)
                    })), J("characterData", (function(e) {
                        n(e)
                    })), Object(l.jsxs)("div", {
                        className: "app",
                        children: [Object(l.jsx)(L, {
                            isCreating: C,
                            tUI: E
                        }), Object(l.jsx)(Y, {
                            isDeleting: S,
                            tUI: E,
                            deleteCharacter: function() {
                                b && S && (I(!1), K("removeCharacter", d).then((function(e) {
                                    O(!1), j({
                                        id: "",
                                        dateofbirth: "",
                                        gender: "",
                                        cash: "",
                                        bank: "",
                                        phone_number: "",
                                        KEK: 0
                                    })
                                })))
                            }
                        }), Object(l.jsxs)("div", {
                            className: "main",
                            style: {
                                display: !f || C || S ? "none" : ""
                            },
                            children: [Object(l.jsxs)("div", {
                                className: "leftSide",
                                children: [Object(l.jsxs)("div", {
                                    className: "titles",
                                    children: [Object(l.jsx)("div", {
                                        className: "title-1",
                                        children: "SELECT"
                                    }), Object(l.jsx)("div", {
                                        className: "title-1 title-2",
                                        children: "CHARACTER"
                                    })]
                                }), Object(l.jsx)("div", {
                                    className: "characterGrid",
                                    children: Array.from(Array(1), (function(e, t) {
                                        return Object(l.jsx)(o, {
                                            value: a[t] || {
                                                id: "Create",
                                                firstname: "Character",
                                                KEK: 0
                                            },
                                            current: d.id,
                                            setCharacter: k
                                        })
                                    }))
                                }), Object(l.jsxs)("div", {
                                    className: "uiButtons",
                                    children: [Object(l.jsx)("div", {
                                        className: "playButton",
                                        onClick: function() {
                                            0 !== d.KEK && d.KEK ? K("selectCharacter", d).then((function(e) {})) : N(!0)
                                        },
                                        children: 0 !== d.KEK && d.KEK ? "Play" : "Create"
                                    }), Object(l.jsx)("div", {
                                        className: "deleteButton",
                                        onClick: function() {
                                            b && (I(!0), N(!1))
                                        },
                                        children: "Delete"
                                    })]
                                })]
                            })]
                        })]
                    })
                };
            i.a.render(Object(l.jsx)(n.a.StrictMode, {
                children: Object(l.jsx)(H, {})
            }), document.getElementById("root"))
        },
        89: function(e, t, a) {}
    },
    [
        [139, 1, 2]
    ]
]);
//# sourceMappingURL=main.83564493.chunk.js.map