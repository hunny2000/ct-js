texture-editor.aPanel.aView
    .flexrow.tall
        .column.borderright.tall.column1.flexfix.nogrow.noshrink
            .flexfix-body
                fieldset
                    b {voc.name}
                    br
                    input.wide(type="text" value="{opts.texture.name}" onchange="{wire('this.texture.name')}")
                    .anErrorNotice(if="{nameTaken}" ref="errorNotice") {vocGlob.nameTaken}
                    label.checkbox
                        input#texturetiled(type="checkbox" checked="{opts.texture.tiled}" onchange="{wire('this.texture.tiled')}")
                        span   {voc.tiled}
                fieldset
                    b {voc.center}
                    .flexrow
                        input.short(type="number" value="{opts.texture.axis[0]}" onchange="{wire('this.texture.axis.0')}" oninput="{wire('this.texture.axis.0')}")
                        span.center ×
                        input.short(type="number" value="{opts.texture.axis[1]}" onchange="{wire('this.texture.axis.1')}" oninput="{wire('this.texture.axis.1')}")
                    .flexrow
                        button.wide.nml(onclick="{textureCenter}")
                            span   {voc.setCenter}
                        .aSpacer
                        button.square.nmr(onclick="{textureIsometrify}" title="{voc.isometrify}")
                            svg.feather
                                use(xlink:href="#map-pin")
                fieldset
                    .toright
                        button.tiny.nmt(if="{sessionStorage.copiedCollisionMask}" onclick="{pasteCollisionMask}" title="{voc.pasteCollisionMask}")
                            svg.feather
                                use(xlink:href="#clipboard")
                        button.tiny.nmt(onclick="{copyCollisionMask}" title="{voc.copyCollisionMask}")
                            svg.feather
                                use(xlink:href="#copy")
                    h3.nmt {voc.form}
                    label.checkbox
                        input(type="radio" name="collisionform" checked="{opts.texture.shape === 'circle'}" onclick="{textureSelectCircle}")
                        span {voc.round}
                    label.checkbox
                        input(type="radio" name="collisionform" checked="{opts.texture.shape === 'rect'}" onclick="{textureSelectRect}")
                        span {voc.rectangle}
                    label.checkbox
                        input(type="radio" name="collisionform" checked="{opts.texture.shape === 'strip'}" onclick="{textureSelectStrip}")
                        span {voc.strip}
                fieldset(if="{opts.texture.shape === 'circle'}")
                    b {voc.radius}
                    br
                    input.wide(type="number" value="{opts.texture.r}" onchange="{wire('this.texture.r')}" oninput="{wire('this.texture.r')}")
                fieldset(if="{opts.texture.shape === 'rect'}")
                    .center.aDashedMaskMarker
                        input.center.short(type="number" value="{opts.texture.top}" onchange="{wire('this.texture.top')}" oninput="{wire('this.texture.top')}")
                        br
                        input.center.short(type="number" value="{opts.texture.left}" onchange="{wire('this.texture.left')}" oninput="{wire('this.texture.left')}")
                        |
                        |
                        span.aPivotSymbol
                        |
                        |
                        input.center.short(type="number" value="{opts.texture.right}" onchange="{wire('this.texture.right')}" oninput="{wire('this.texture.right')}")
                        br
                        input.center.short(type="number" value="{opts.texture.bottom}" onchange="{wire('this.texture.bottom')}" oninput="{wire('this.texture.bottom')}")
                    button.wide(onclick="{textureFillRect}")
                        svg.feather
                            use(xlink:href="#maximize")
                        span {voc.fill}
                fieldset(if="{opts.texture.shape === 'strip'}")
                    .flexrow.aStripPointRow(each="{point, ind in getMovableStripPoints()}")
                        input.short(type="number" value="{point.x}" oninput="{wire('this.texture.stripPoints.'+ ind + '.x')}")
                        span   ×
                        input.short(type="number" value="{point.y}" oninput="{wire('this.texture.stripPoints.'+ ind + '.y')}")
                        button.square.inline(title="{voc.removePoint}" onclick="{removeStripPoint}")
                            svg.feather
                                use(xlink:href="#minus")
                    button.wide(onclick="{addStripPoint}")
                        svg.feather
                            use(xlink:href="#plus")
                        span   {voc.addPoint}
                fieldset(if="{opts.texture.shape === 'strip'}")
                    label.checkbox
                        input(type="checkbox" checked="{opts.texture.closedStrip}" onchange="{onClosedStripChange}" )
                        span   {voc.closeShape}
                    label.checkbox
                        input(type="checkbox" checked="{opts.texture.symmetryStrip}" onchange="{onSymmetryChange}")
                        span   {voc.symmetryTool}
                fieldset
                    label.checkbox
                        input(checked="{prevShowMask}" onchange="{wire('this.prevShowMask')}" type="checkbox")
                        span   {voc.showMask}
                    label.checkbox(if="{opts.texture.width > 10 && opts.texture.height > 10}")
                        input(checked="{prevShowFrameIndices}" onchange="{wire('this.prevShowFrameIndices')}" type="checkbox")
                        span   {voc.showFrameIndices}
            .flexfix-footer
                button.wide(onclick="{textureSave}" title="Shift+Control+S" data-hotkey="Control+S")
                    svg.feather
                        use(xlink:href="#save")
                    span {window.languageJSON.common.save}
        .texture-editor-anAtlas.tall(
            if="{opts.texture}"
            style="background-color: {previewColor};"
            onmousewheel="{onMouseWheel}"
        )
            .texture-editor-aCanvasWrap
                canvas.texture-editor-aCanvas(
                    ref="textureCanvas"
                    style="transform: scale({zoomFactor}); image-rendering: {zoomFactor > 1? 'pixelated' : '-webkit-optimize-contrast'}; transform-origin: 0% 0%;"
                )
                // This div is needed to cause elements' reflow so the scrollbars update on canvas' size change
                div(style="width: {zoomFactor}px; height: {zoomFactor}px;")
                .aClicker(
                    if="{prevShowMask && opts.texture.shape === 'strip' && getStripSegments()}"
                    each="{seg, ind in getStripSegments()}"
                    style="left: {seg.left}px; top: {seg.top}px; width: {seg.width}px; transform: translate(0, -50%) rotate({seg.angle}deg);"
                    title="{voc.addPoint}"
                    onmousedown="{addStripPointOnSegment}"
                )
                .aDragger(
                    if="{prevShowMask}"
                    style="left: {opts.texture.axis[0] * zoomFactor}px; top: {opts.texture.axis[1] * zoomFactor}px; border-radius: 0;"
                    title="{voc.moveCenter}"
                    onmousedown="{startMoving('axis')}"
                )
                .aDragger(
                    if="{prevShowMask && opts.texture.shape === 'strip'}"
                    each="{point, ind in getMovableStripPoints()}"
                    style="left: {(point.x + texture.axis[0]) * zoomFactor}px; top: {(point.y + texture.axis[1]) * zoomFactor}px;"
                    title="{voc.movePoint}"
                    onmousedown="{startMoving('point')}"
                    oncontextmenu="{removeStripPoint}"
                )
            .texture-editor-Tools
                .toright
                    label.file(title="{voc.replaceTexture}")
                        input(type="file" ref="textureReplacer" accept=".png,.jpg,.jpeg,.bmp,.gif" onchange="{textureReplace}")
                        .button.inline.forcebackground
                            svg.feather
                                use(xlink:href="#folder")
                            span {voc.replaceTexture}
                    .button.inline.forcebackground(
                        if="{opts.texture.source}"
                        title="{voc.reimport} (Control+R)"
                        onclick="{reimport}"
                        data-hotkey="Control+r"
                    )
                        svg.feather
                            use(xlink:href="#refresh-ccw")
                    .button.inline.forcebackground(
                        title="{voc.updateFromClipboard} (Control+V)"
                        onclick="{paste}"
                        data-hotkey="Control+v"
                        data-hotkey-require-scope="texture"
                        data-hotkey-priority="10"
                    )
                        svg.feather
                            use(xlink:href="#clipboard")
            .textureview-zoom.flexrow
                b.aContrastingPlaque {Math.round(zoomFactor * 100)}%
                .aSpacer
                zoom-slider(onchanged="{setZoom}" ref="zoomslider" value="{zoomFactor}")
            .textureview-bg
                button.inline.forcebackground(onclick="{changePreviewBg}")
                    svg.feather
                        use(xlink:href="#droplet")
                    span {voc.bgColor}
        .column.column2.borderleft.tall.flexfix.nogrow.noshrink(show="{!texture.tiled}")
            .flexfix-body
                fieldset
                    .flexrow
                        div
                            b {voc.cols}
                            br
                            input.wide(
                                type="number"
                                value="{texture.grid[0]}"
                                onchange="{wire('this.texture.grid.0')}"
                                oninput="{wire('this.texture.grid.0')}"
                                min="1"
                            )
                        span &nbsp;
                        div
                            b {voc.rows}
                            br
                            input.wide(
                                type="number"
                                value="{texture.grid[1]}"
                                onchange="{wire('this.texture.grid.1')}"
                                oninput="{wire('this.texture.grid.1')}"
                                min="1"
                            )
                    .flexrow
                        div
                            b {voc.width}
                            br
                            input.wide(
                                type="number"
                                value="{texture.width}"
                                onchange="{wire('this.texture.width')}"
                                oninput="{wire('this.texture.width')}"
                                min="1"
                            )
                        span &nbsp;
                        div
                            b {voc.height}
                            br
                            input.wide(
                                type="number"
                                value="{texture.height}"
                                onchange="{wire('this.texture.height')}"
                                oninput="{wire('this.texture.height')}"
                                min="1"
                            )
                fieldset
                    .flexrow
                        div
                            b {voc.marginX}
                            br
                            input.wide(
                                type="number"
                                value="{texture.marginx}"
                                onchange="{wire('this.texture.marginx')}"
                                oninput="{wire('this.texture.marginx')}"
                                min="0"
                            )
                        span &nbsp;
                        div
                            b {voc.marginY}
                            br
                            input.wide(
                                type="number"
                                value="{texture.marginy}"
                                onchange="{wire('this.texture.marginy')}"
                                oninput="{wire('this.texture.marginy')}"
                                min="0"
                            )
                    .flexrow
                        div
                            b {voc.offX}
                            br
                            input.wide(
                                type="number"
                                value="{texture.offx}"
                                onchange="{wire('this.texture.offx')}"
                                oninput="{wire('this.texture.offx')}"
                                min="0"
                            )
                        span &nbsp;
                        div
                            b {voc.offY}
                            br
                            input.wide(
                                type="number"
                                value="{texture.offy}"
                                onchange="{wire('this.texture.offy')}"
                                oninput="{wire('this.texture.offy')}"
                                min="0"
                            )
                fieldset
                    b {voc.frames}
                    br
                    input#textureframes.wide(
                        type="number"
                        value="{texture.untill}"
                        onchange="{wire('this.texture.untill')}"
                        oninput="{wire('this.texture.untill')}"
                        min="0"
                    )
                fieldset
                    b
                        span {voc.padding}
                        hover-hint(text="{voc.paddingNotice}")
                    br
                    input.wide(
                        type="number"
                        min="0" max="128" step="1"
                        value="{texture.padding}"
                        onchange="{wire('this.texture.padding')}"
                    )
            .preview.bordertop.flexfix-footer
                .texture-editor-anAnimationPreview(
                    ref="preview"
                    style="background-color: {previewColor};"
                )
                    canvas(
                        ref="grprCanvas"
                        style="image-rendering: {currentProject.settings.rendering.pixelatedrender? 'pixelated' : '-webkit-optimize-contrast'};"
                    )
                .flexrow
                    button.nogrow.square.inline(onclick="{previewPlayPause}")
                        svg.feather
                            use(xlink:href="#{prevPlaying? 'pause' : 'play'}")
                    span(ref="textureviewframe") 0 / 1
                    button.nogrow.square.inline(onclick="{previewBack}")
                        svg.feather
                            use(xlink:href="#skip-back")
                    button.nogrow.square.inline.nmr(onclick="{previewNext}")
                        svg.feather
                            use(xlink:href="#skip-forward")
                .flexrow
                    b.alignmiddle {voc.speed}
                    .filler
                    input.texture-editor-anAnimSpeedField.short(type="number" min="1" value="{prevSpeed}" onchange="{wire('this.prevSpeed')}" oninput="{wire('this.prevSpeed')}")
                p
                .aNotice {voc.previewAnimationNotice}

    color-picker(
        ref="previewBackgroundColor" if="{changingPreviewBg}"
        hidealpha="true"
        color="{previewColor}" onapply="{updatePreviewColor}" onchanged="{updatePreviewColor}" oncancel="{cancelPreviewColor}"
    )
    script.
        const path = require('path'),
              fs = require('fs-extra');
        const glob = require('./data/node_requires/glob');
        this.namespace = 'textureView';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);

        this.nameTaken = false;
        this.prevPlaying = true;
        this.prevPos = 0;
        this.prevSpeed = 10;
        this.prevShowMask = this.prevShowFrameIndices = true;
        this.previewColor = localStorage.UItheme === 'Day' ? '#ffffff' : '#08080D';
        this.zoomFactor = 1;

        var textureCanvas, grprCanvas;

        this.on('mount', () => {
            ({textureCanvas, grprCanvas} = this.refs);
            textureCanvas.x = textureCanvas.getContext('2d');
            grprCanvas.x = grprCanvas.getContext('2d');
            const texture = this.texture = this.opts.texture;
            const img = document.createElement('img');
            img.onload = () => {
                textureCanvas.img = img;
                this.update();
                setTimeout(() => {
                    this.launchTexturePreview();
                }, 0);
            };
            img.onerror = e => {
                alertify.error(window.languageJSON.textureView.corrupted);
                console.error(e);
                this.textureSave();
            };
            img.src = path.join('file://', global.projdir, '/img/', texture.origname) + '?' + Math.random();
        });
        this.on('update', () => {
            const {textures} = global.currentProject;
            const t = this.texture;
            if (textures.find(texture => t.name === texture.name && t !== texture)) {
                this.nameTaken = true;
            } else {
                this.nameTaken = false;
            }
            const {textureCanvas} = this.refs;
            const {img} = textureCanvas;
            // Enforce positive/zero values
            for (const prop of ['marginx', 'marginy', 'offx', 'offy', 'untill', 'padding']) {
                if (t[prop] < 0) {
                    t[prop] = 0;
                }
            }
            for (const prop of ['width', 'height']) {
                if (t[prop] < 1) {
                    t[prop] = 1;
                }
            }
            if (t.grid[0] < 1) {
                t.grid[0] = 1;
            }
            if (t.grid[1] < 1) {
                t.grid[1] = 1;
            }
            // Calculate frame width for the user if it exceeds image size
            if (t.grid[0] * (t.width + t.marginx) - t.marginx > img.width - t.offx) {
                t.width = Math.floor((img.width - t.offx) / t.grid[0] - t.marginx);
            }
            if (t.grid[1] * (t.height + t.marginy) - t.marginy > img.height - t.offy) {
                t.height = Math.floor((img.height - t.offy) / t.grid[1] - t.marginy);
            }
            // Preset frame count can't be larger than the grid table size
            if (t.untill > t.grid[0] * t.grid[1]) {
                t.untill = t.grid[0] * t.grid[1];
            }
            this.updateSymmetricalPoints();
        });
        this.on('updated', () => {
            this.refreshTextureCanvas();
        });
        this.on('unmount', () => {
            if (this.prevPlaying) { // Need to clear a setTimeout handle to prevent memory leaks
                this.stopTexturePreview();
            }
        });

        this.textureReplace = () => {
            const val = this.refs.textureReplacer.files[0].path;
            if (/\.(jpg|gif|png|jpeg)/gi.test(val)) {
                this.loadImg(
                    val,
                    global.projdir + '/img/i' + this.texture.uid + path.extname(val)
                );
                this.texture.source = val;
            } else {
                alertify.error(window.languageJSON.common.wrongFormat);
            }
            this.refs.textureReplacer.value = '';
        };
        this.reimport = () => {
            this.loadImg(
                this.texture.source,
                global.projdir + '/img/i' + this.texture.uid + path.extname(this.texture.source)
            );
        };
        this.paste = async () => {
            const png = nw.Clipboard.get().get('png');
            if (!png) {
                alertify.error(this.vocGlob.couldNotLoadFromClipboard);
                return;
            }
            const imageBase64 = png.replace(/^data:image\/\w+;base64,/, '');
            const imageBuffer = new Buffer(imageBase64, 'base64');
            await this.loadImg(
                imageBuffer,
                global.projdir + '/img/i' + this.texture.uid + '.png'
            );
            alertify.success(this.vocGlob.pastedFromClipboard);
        };

        /**
         * Loads an image into the project, generating thumbnails and updating the preview.
         * @param {String|Buffer} filename A source image. It can be either a full path in a file system,
         * or a buffer.
         * @param {Sting} dest The path to write to.
         */
        this.loadImg = async (filename, dest) => {
            try {
                if (filename instanceof Buffer) {
                    await fs.writeFile(dest, filename);
                } else {
                    await fs.copy(filename, dest);
                }
                const image = document.createElement('img');
                image.onload = () => {
                    this.texture.imgWidth = image.width;
                    this.texture.imgHeight = image.height;
                    if (this.texture.tiled || (
                        this.texture.grid[0] === 1 &&
                        this.texture.grid[1] === 1 &&
                        this.texture.offx === 0 &&
                        this.texture.offy === 0
                    )) {
                        this.texture.width = this.texture.imgWidth;
                        this.texture.height = this.texture.imgHeight;
                    }
                    this.texture.origname = path.basename(dest);
                    textureCanvas.img = image;
                    this.texture.lastmod = Number(new Date());

                    const {textureGenPreview} = require('./data/node_requires/resources/textures');
                    textureGenPreview(this.texture, dest + '_prev.png', 64, () => {
                        this.update();
                    });
                    textureGenPreview(this.texture, dest + '_prev@2.png', 128);
                    setTimeout(() => {
                        this.refreshTextureCanvas();
                        this.parent.fillTextureMap();
                        this.launchTexturePreview();
                    }, 0);
                };
                image.onerror = e => {
                    alertify.error(e);
                };
                image.src = 'file://' + dest + '?' + Math.random();
            } catch (e) {
                alertify.error(e);
                throw e;
            }
        };

        this.setZoom = zoom => {
            this.zoomFactor = zoom;
            this.update();
        };
        /** Change zoomFactor on mouse wheel roll */
        this.onMouseWheel = e => {
            if (e.wheelDelta > 0) {
                this.refs.zoomslider.zoomIn();
            } else {
                this.refs.zoomslider.zoomOut();
            }
            e.preventDefault();
            this.update();
        };

        /**
         * Установить ось вращения на центр изображения
         */
        this.textureCenter = () => {
            const {texture} = this;
            let needsRefilling = false;
            if (texture.left === Math.floor(texture.axis[0]) &&
                texture.top === Math.floor(texture.axis[1]) &&
                texture.right === Math.ceil(texture.width - texture.axis[0]) &&
                texture.bottom === Math.ceil(texture.height - texture.axis[1])
            ) {
                needsRefilling = true;
            }
            texture.axis[0] = Math.floor(texture.width / 2);
            texture.axis[1] = Math.floor(texture.height / 2);
            if (needsRefilling) {
                this.textureFillRect();
            }
        };
        /**
         * Заполнить всё изображение маской-квадратом
         */
        this.textureFillRect = () => {
            const {texture} = this;
            texture.left = Math.floor(texture.axis[0]);
            texture.top = Math.floor(texture.axis[1]);
            texture.right = Math.ceil(texture.width - texture.axis[0]);
            texture.bottom = Math.ceil(texture.height - texture.axis[1]);
        };
        this.textureIsometrify = () => {
            const {texture} = this;
            texture.axis[0] = Math.floor(texture.width / 2);
            texture.axis[1] = texture.height;
            this.textureFillRect();
        };
        this.pasteCollisionMask = () => {
            if (!sessionStorage.copiedCollisionMask) {
                return;
            }
            Object.assign(this.texture, JSON.parse(sessionStorage.copiedCollisionMask));
        };
        this.copyCollisionMask = () => {
            const {texture} = this;
            sessionStorage.copiedCollisionMask = JSON.stringify({
                shape: texture.shape,
                stripPoints: texture.stripPoints,
                left: texture.left,
                right: texture.right,
                top: texture.top,
                bottom: texture.bottom,
                r: texture.r
            });
        };

        /**
         * Запустить предпросмотр анимации
         */
        this.previewPlayPause = () => {
            if (this.prevPlaying) {
                this.stopTexturePreview();
            } else {
                this.launchTexturePreview();
            }
            this.prevPlaying = !this.prevPlaying;
        };
        /**
         * Отступить на шаг назад в предпросмотре анимации
         */
        this.previewBack = () => {
            this.prevPos--;
            const {texture} = this;
            const total = texture.untill === 0 ?
                texture.grid[0] * texture.grid[1] :
                Math.min(texture.grid[0] * texture.grid[1], texture.untill);
            if (this.prevPos < 0) {
                this.prevPos = texture.untill === 0 ? texture.grid[0] * texture.grid[1] : total - 0;
            }
            this.refreshPreviewCanvas();
        };
        /**
         * Шагнуть на кадр вперёд в предпросмотре анимации
         */
        this.previewNext = () => {
            this.prevPos++;
            const {texture} = this;
            const total = texture.untill === 0 ?
                texture.grid[0] * texture.grid[1] :
                Math.min(texture.grid[0] * texture.grid[1], texture.untill);
            if (this.prevPos >= total) {
                this.prevPos = 0;
            }
            this.refreshPreviewCanvas();
        };
        this.refreshPreviewCanvas = () => {
            const xx = this.prevPos % this.texture.grid[0],
                  yy = Math.floor(this.prevPos / this.texture.grid[0]),
                  x = this.texture.offx + xx * (this.texture.marginx + this.texture.width),
                  y = this.texture.offy + yy * (this.texture.marginy + this.texture.height),
                  w = this.texture.width,
                  h = this.texture.height;
            grprCanvas.width = w;
            grprCanvas.height = h;

            grprCanvas.x.clearRect(0, 0, grprCanvas.width, grprCanvas.height);
            grprCanvas.x.drawImage(
                textureCanvas.img,
                x, y, w, h,
                0, 0, w, h
            );
            // shape
            if (this.prevShowMask) {
                grprCanvas.x.globalAlpha = 0.5;
                grprCanvas.x.fillStyle = '#ff0';
                if (this.texture.shape === 'rect') {
                    grprCanvas.x.fillRect(
                        this.texture.axis[0] - this.texture.left,
                        this.texture.axis[1] - this.texture.top,
                        this.texture.right + this.texture.left,
                        this.texture.bottom + this.texture.top
                    );
                } else if (this.texture.shape === 'circle') {
                    grprCanvas.x.beginPath();
                    grprCanvas.x.arc(
                        this.texture.axis[0], this.texture.axis[1],
                        this.texture.r,
                        0, 2 * Math.PI
                    );
                    grprCanvas.x.fill();
                } else if (this.texture.shape === 'strip' && this.texture.stripPoints.length) {
                    grprCanvas.x.strokeStyle = '#ff0';
                    grprCanvas.x.lineWidth = 3;
                    grprCanvas.x.beginPath();
                    grprCanvas.x.moveTo(
                        this.texture.stripPoints[0].x + this.texture.axis[0],
                        this.texture.stripPoints[0].y + this.texture.axis[1]
                    );
                    for (let i = 1, l = this.texture.stripPoints.length; i < l; i++) {
                        grprCanvas.x.lineTo(
                            this.texture.stripPoints[i].x + this.texture.axis[0],
                            this.texture.stripPoints[i].y + this.texture.axis[1]
                        );
                    }
                    if (this.texture.closedStrip) {
                        grprCanvas.x.closePath();
                    }
                    grprCanvas.x.stroke();
                }
                grprCanvas.x.globalAlpha = 1;
                grprCanvas.x.fillStyle = '#f33';
                grprCanvas.x.beginPath();
                grprCanvas.x.arc(this.texture.axis[0], this.texture.axis[1], 3, 0, 2 * Math.PI);
                grprCanvas.x.fill();
            }
        };
        /**
         * Stops the animated preview
         */
        this.stopTexturePreview = () => {
            window.clearTimeout(this.prevTime);
        };
        /**
         * Starts the preview of a framed animation
         */
        this.launchTexturePreview = () => {
            if (this.prevTime) {
                window.clearTimeout(this.prevTime);
            }
            this.prevPos = 0;
            this.stepTexturePreview();
        };
        /**
         * Шаг анимации в предпросмотре. Выполняет рендер. Записывает таймер следующего шага в this.prevTime
         */
        this.stepTexturePreview = () => {
            const {texture} = this;
            this.prevTime = window.setTimeout(() => {
                const total = Math.min(
                    texture.untill === 0 ? Infinity : texture.untill,
                    texture.grid[0] * texture.grid[1]
                );
                this.prevPos++;
                if (this.prevPos >= total) {
                    this.prevPos = 0;
                }
                this.refs.textureviewframe.innerHTML = `${this.prevPos} / ${total}`;
                if (!this.texture.tiled) {
                    this.refreshPreviewCanvas();
                }
                this.stepTexturePreview();
            }, 1000 / this.prevSpeed);
        };

        /**
         * Переключает тип маски на круг и выставляет начальные параметры
         */
        this.textureSelectCircle = function textureSelectCircle() {
            this.texture.shape = 'circle';
            if (!('r' in this.texture) || this.texture.r === 0) {
                this.texture.r = Math.min(
                    Math.floor(this.texture.width / 2),
                    Math.floor(this.texture.height / 2)
                );
            }
        };
        /**
         * Переключает тип маски на прямоугольник и выставляет начальные параметры
         */
        this.textureSelectRect = function textureSelectRect() {
            this.texture.shape = 'rect';
            this.textureFillRect();
        };
        /**
         * Переключает тип маски на ломаную/многоугольник и выставляет начальные параметры
         */
        this.textureSelectStrip = function textureSelectStrip() {
            this.texture.shape = 'strip';
            this.texture.stripPoints = this.texture.stripPoints || [];
            if (!this.texture.stripPoints.length) {
                const twoPi = Math.PI * 2;
                this.texture.closedStrip = true;
                for (let i = 0; i < 5; i++) {
                    this.texture.stripPoints.push({
                        x: Math.round(Math.sin(twoPi / 5 * i) * this.texture.width / 2),
                        y: -Math.round(Math.cos(twoPi / 5 * i) * this.texture.height / 2)
                    });
                }
            }
        };
        this.removeStripPoint = function removeStripPoint(e) {
            if (this.texture.symmetryStrip) {
                // Remove an extra point
                this.texture.stripPoints.pop();
            }
            this.texture.stripPoints.splice(e.item.ind, 1);
            e.preventDefault();
        };
        this.addStripPoint = function addStripPoint() {
            this.texture.stripPoints.push({
                x: 0,
                y: 16
            });
        };
        this.addStripPointOnSegment = e => {
            const {top, left} = textureCanvas.getBoundingClientRect();
            const point = {
                x: (e.pageX - left) / this.zoomFactor - this.texture.axis[0],
                y: (e.pageY - top) / this.zoomFactor - this.texture.axis[1]
            };
            this.texture.stripPoints.splice(e.item.ind + 1, 0, point);
            if (this.texture.symmetryStrip) {
                // Add an extra point (the symetrical point)
                this.addStripPoint();
            }
            this.startMoving('point', point)(e);
        };
        this.pointToLine = (linePoint1, linePoint2, point) => {
            const dlx = linePoint2.x - linePoint1.x;
            const dly = linePoint2.y - linePoint1.y;
            const lineLength = Math.sqrt(dlx * dlx + dly * dly);
            const lineAngle = Math.atan2(dly, dlx);

            const dpx = point.x - linePoint1.x;
            const dpy = point.y - linePoint1.y;
            const toPointLength = Math.sqrt(dpx * dpx + dpy * dpy);
            const toPointAngle = Math.atan2(dpy, dpx);

            const distance = toPointLength * Math.cos(toPointAngle - lineAngle);

            return {
                x: linePoint1.x + distance * dlx / lineLength,
                y: linePoint1.y + distance * dly / lineLength
            };
        };
        this.onClosedStripChange = () => {
            this.texture.closedStrip = !this.texture.closedStrip;
            if (!this.texture.closedStrip && this.texture.symmetryStrip) {
                this.onSymmetryChange();
            }
        };
        this.onSymmetryChange = () => {
            if (this.texture.symmetryStrip) {
                this.texture.stripPoints = this.getMovableStripPoints();
            } else {
                const nbPointsToAdd = this.texture.stripPoints.length - 2;
                for (let i = 0; i < nbPointsToAdd; i++) {
                    this.addStripPoint();
                }
                this.texture.closedStrip = true; // Force closedStrip to true
            }

            this.texture.symmetryStrip = !this.texture.symmetryStrip;
            this.update();
        };
        this.startMoving = (which, point) => e => {
            if (e.button !== 0) {
                return;
            }
            const startX = e.screenX,
                  startY = e.screenY;
            if (which === 'axis') {
                const [oldX, oldY] = this.texture.axis;
                const func = e => {
                    this.texture.axis[0] = (e.screenX - startX) / this.zoomFactor + oldX;
                    this.texture.axis[1] = (e.screenY - startY) / this.zoomFactor + oldY;
                    this.update();
                };
                const func2 = () => {
                    document.removeEventListener('mousemove', func);
                    document.removeEventListener('mouseup', func2);
                };
                document.addEventListener('mousemove', func);
                document.addEventListener('mouseup', func2);
            } else if (which === 'point') {
                point = point || e.item.point;
                const oldX = point.x,
                      oldY = point.y;
                let hasMoved = false;
                const func = e => {
                    if (!hasMoved && (e.screenX !== startX || e.screenY !== startY)) {
                        hasMoved = true;
                    }
                    point.x = (e.screenX - startX) / this.zoomFactor + oldX;
                    point.y = (e.screenY - startY) / this.zoomFactor + oldY;
                    this.update();
                };
                const func2 = () => {
                    if (!hasMoved) {
                        this.removeStripPoint(e);
                        this.update();
                    }
                    document.removeEventListener('mousemove', func);
                    document.removeEventListener('mouseup', func2);
                };
                document.addEventListener('mousemove', func);
                document.addEventListener('mouseup', func2);
            }
        };

        this.drawMask = () => {
            const tc = textureCanvas;
            tc.x.fillStyle = '#ff0';
            tc.x.globalAlpha = 0.5;
            if (this.texture.shape === 'rect') {
                tc.x.fillRect(
                    this.texture.axis[0] - this.texture.left,
                    this.texture.axis[1] - this.texture.top,
                    this.texture.right + this.texture.left,
                    this.texture.bottom + this.texture.top
                );
            } else if (this.texture.shape === 'circle') {
                tc.x.beginPath();
                tc.x.arc(
                    this.texture.axis[0],
                    this.texture.axis[1],
                    this.texture.r,
                    0, 2 * Math.PI
                );
                tc.x.fill();
            } else if (this.texture.shape === 'strip' && this.texture.stripPoints.length) {
                tc.x.strokeStyle = '#ff0';
                tc.x.lineWidth = 3;
                tc.x.beginPath();
                tc.x.moveTo(
                    this.texture.stripPoints[0].x + this.texture.axis[0],
                    this.texture.stripPoints[0].y + this.texture.axis[1]
                );
                for (let i = 1, l = this.texture.stripPoints.length; i < l; i++) {
                    tc.x.lineTo(
                        this.texture.stripPoints[i].x + this.texture.axis[0],
                        this.texture.stripPoints[i].y + this.texture.axis[1]
                    );
                }
                if (this.texture.closedStrip) {
                    tc.x.closePath();
                }
                tc.x.stroke();

                if (this.texture.symmetryStrip) {
                    const movablePoints = this.getMovableStripPoints();
                    const [axisPoint1] = movablePoints;
                    const axisPoint2 = movablePoints[movablePoints.length - 1];

                    // Draw symmetry axis
                    tc.x.strokeStyle = '#f00';
                    tc.x.lineWidth = 3;
                    tc.x.beginPath();
                    tc.x.moveTo(
                        axisPoint1.x + this.texture.axis[0],
                        axisPoint1.y + this.texture.axis[1]
                    );
                    tc.x.lineTo(
                        axisPoint2.x + this.texture.axis[0],
                        axisPoint2.y + this.texture.axis[1]
                    );
                    tc.x.stroke();
                }
            }
        };
        /**
         * Redraws the canvas with the full image, its collision mask, and its slicing grid
         */
        this.refreshTextureCanvas = () => {
            const tc = textureCanvas;
            tc.width = tc.img.width;
            tc.height = tc.img.height;
            tc.x.strokeStyle = '#0ff';
            tc.x.lineWidth = 1;
            tc.x.font = '10px sans-serif';
            tc.x.textAlign = 'left';
            tc.x.textBaseline = 'top';
            tc.x.globalCompositeOperation = 'source-over';
            tc.x.clearRect(0, 0, tc.width, tc.height);
            tc.x.drawImage(tc.img, 0, 0);
            if (!this.texture.tiled) {
                const l = Math.min(
                    this.texture.grid[0] * this.texture.grid[1],
                    this.texture.untill || Infinity
                );
                for (let i = 0; i < l; i++) {
                    const xx = i % this.texture.grid[0],
                          yy = Math.floor(i / this.texture.grid[0]),
                          x = this.texture.offx + xx * (this.texture.marginx + this.texture.width),
                          y = this.texture.offy + yy * (this.texture.marginy + this.texture.height),
                          w = this.texture.width,
                          h = this.texture.height;
                    tc.x.globalAlpha = 0.5;
                    tc.x.strokeStyle = '#0ff';
                    tc.x.lineWidth = 1;
                    tc.x.strokeRect(x, y, w, h);
                    if (this.prevShowFrameIndices &&
                        this.opts.texture.width > 10 &&
                        this.opts.texture.height > 10
                    ) {
                        tc.x.lineWidth = 2;
                        tc.x.globalAlpha = 1;
                        tc.x.strokeStyle = '#000';
                        tc.x.fillStyle = '#fff';
                        tc.x.strokeText(i, x + 2, y + 2);
                        tc.x.fillText(i, x + 2, y + 2);
                    }
                }
            }
            if (this.prevShowMask) {
                this.drawMask();
            }
        };

        /**
         * Событие сохранения графики
         */
        this.textureSave = () => {
            if (this.nameTaken) {
                // animate the error notice
                require('./data/node_requires/jellify')(this.refs.errorNotice);
                const {soundbox} = require('./data/node_requires/3rdparty/soundbox');
                soundbox.play('Failure');
                return false;
            }
            this.parent.fillTextureMap();
            glob.modified = true;
            this.texture.lastmod = Number(new Date());
            const {textureGenPreview, updatePixiTexture} = require('./data/node_requires/resources/textures');
            updatePixiTexture(this.texture)
            .then(() => {
                window.signals.trigger('pixiTextureChanged', this.texture.uid);
            });
            textureGenPreview(this.texture, global.projdir + '/img/' + this.texture.origname + '_prev@2.png', 128);
            textureGenPreview(this.texture, global.projdir + '/img/' + this.texture.origname + '_prev.png', 64)
            .then(() => {
                this.parent.editing = false;
                this.parent.update();
            });
            return true;
        };

        this.changePreviewBg = () => {
            this.changingPreviewBg = !this.changingPreviewBg;
            if (this.changingPreviewBg) {
                this.oldPreviewColor = this.previewColor;
            }
        };
        this.updatePreviewColor = (color, evtype) => {
            this.previewColor = color;
            if (evtype === 'onapply') {
                this.changingPreviewBg = false;
            }
            this.update();
        };
        this.cancelPreviewColor = () => {
            this.changingPreviewBg = false;
            this.previewColor = this.oldPreviewColor;
            this.update();
        };
        this.getMovableStripPoints = () => {
            if (!this.texture) {
                return false;
            }
            const points = this.texture.stripPoints;
            if (!this.texture.symmetryStrip) {
                return points;
            }
            return points.slice(0, 2 + Math.round((points.length - 2) / 2));
        };
        this.getStripSegments = () => {
            if (!this.texture) {
                return false;
            }
            if (this.texture.shape !== 'strip') {
                return false;
            }

            const points = this.getMovableStripPoints();
            const segs = [];

            for (let i = 0; i < points.length; i++) {
                const point1 = points[i];
                const point2 = points[(i + 1) % points.length];

                const x1 = (point1.x + this.texture.axis[0]) * this.zoomFactor;
                const y1 = (point1.y + this.texture.axis[1]) * this.zoomFactor;
                const x2 = (point2.x + this.texture.axis[0]) * this.zoomFactor;
                const y2 = (point2.y + this.texture.axis[1]) * this.zoomFactor;
                const dx = x2 - x1;
                const dy = y2 - y1;

                const length = Math.sqrt(dx * dx + dy * dy);
                const cssAngle = Math.atan2(dy, dx) * 180 / Math.PI;

                segs.push({
                    left: x1,
                    top: y1,
                    width: length,
                    angle: cssAngle
                });
            }

            return segs;
        };
        this.updateSymmetricalPoints = () => {
            if (this.texture && this.texture.symmetryStrip) {
                const movablePoints = this.getMovableStripPoints();
                const [axisPoint1] = movablePoints;
                const axisPoint2 = movablePoints[movablePoints.length - 1];
                for (let i = 1; i < movablePoints.length - 1; i++) {
                    const j = this.texture.stripPoints.length - i;
                    const point = movablePoints[i];
                    const axisPoint = this.pointToLine(axisPoint1, axisPoint2, point);
                    this.texture.stripPoints[j] = {
                        x: 2 * axisPoint.x - point.x,
                        y: 2 * axisPoint.y - point.y
                    };
                }
            }
        };

