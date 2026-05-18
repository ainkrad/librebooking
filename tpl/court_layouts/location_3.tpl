<style>
:root {
    --court-green: #0B3C0D;
    --bg-red: #7A0000;
    --court-line: #ffffff;
    
    /* Vertical court sizes */
    --v-court-w: 140px;
    --v-court-h: calc(var(--v-court-w) * 2.2); /* 308px */

    /* Horizontal court sizes (Inverted aspect ratios) */
    --h-court-h: 140px;
    --h-court-w: calc(var(--h-court-h) * 2.2); /* 308px */
}

/* Red Container Wrapper */


/* Master Reset for All Interactive Courts */
.court-interactive-trigger {
    background-color: var(--court-green);
    border: 2px solid var(--court-line);
    border-radius: 4px;
    cursor: pointer;
    position: relative;
    box-sizing: border-box;
    padding: 0;
    margin: 0;
    outline: none;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.court-interactive-trigger:hover {
    transform: scale(1.02);
}
.court-interactive-trigger.active-selection {
    transform: scale(1.02);
    box-shadow: 0 0 0 5px #1E88E5 !important;
    border-color: #1E88E5 !important;
}

/* Absolute Positioning Layout Frame */
.court-lines-wrapper {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    display: flex;
}

.court-center-label {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: rgba(255, 255, 255, 0.45);
    font-family: Arial, sans-serif;
    font-weight: bold;
    font-size: 26px;
    pointer-events: none;
    z-index: 10;
}

/* ========================================== */
/* 1. VERTICAL COURT ENGINE SPECIFIC STYLES   */
/* ========================================== */
.v-court {
    width: var(--v-court-w);
    height: var(--v-court-h);
}
.v-wrapper { flex-direction: column; }
.v-baseline-top {
    height: calc((15 / 44) * 100%);
    border-bottom: 2px solid var(--court-line);
    position: relative;
}
.v-baseline-top::after, .v-baseline-bottom::after {
    content: ''; position: absolute; top: 0; bottom: 0; left: 50%;
    transform: translateX(-50%); border-left: 2px solid var(--court-line);
}
.v-kitchen-top {
    height: calc((7 / 44) * 100%);
    border-bottom: 2px dashed rgba(255, 255, 255, 0.7);
}
.v-kitchen-bottom {
    height: calc((7 / 44) * 100%);
    border-bottom: 2px solid var(--court-line);
}
.v-baseline-bottom {
    height: calc((15 / 44) * 100%);
    position: relative;
}

/* ========================================== */
/* 2. HORIZONTAL COURT ENGINE SPECIFIC STYLES */
/* ========================================== */
.h-court {
    width: var(--h-court-w);
    height: var(--h-court-h);
}
.h-wrapper { flex-direction: row; } /* Draws columns left to right instead of top to bottom */
.h-baseline-left {
    width: calc((15 / 44) * 100%);
    border-right: 2px solid var(--court-line);
    position: relative;
}
.h-baseline-left::after, .h-baseline-right::after {
    content: ''; position: absolute; left: 0; right: 0; top: 50%;
    transform: translateY(-50%); border-top: 2px solid var(--court-line); /* Draws center line horizontally */
}
.h-kitchen-left {
    width: calc((7 / 44) * 100%);
    border-right: 2px dashed rgba(255, 255, 255, 0.7); /* Net line shifts to vertical axis orientation */
}
.h-kitchen-right {
    width: calc((7 / 44) * 100%);
    border-right: 2px solid var(--court-line);
}
.h-baseline-right {
    width: calc((15 / 44) * 100%);
    position: relative;
}
</style>

<div style="text-align: center; padding: 10px;">
    <p style="color:#666; font-size:14px; margin-bottom:15px;">Tap an available court layout to pick:</p>

    <div class="venue-floorplan-bg">
        
        <div style="display: flex; gap: 25px;">
            <button type="button" class="court-interactive-trigger v-court dynamic-court-btn" data-court-id="1">
                <div class="court-center-label">A1</div>
                <div class="court-lines-wrapper v-wrapper">
                    <div class="v-baseline-top"></div>
                    <div class="v-kitchen-top"></div>
                    <div class="v-kitchen-bottom"></div>
                    <div class="v-baseline-bottom"></div>
                </div>
            </button>

            <button type="button" class="court-interactive-trigger v-court dynamic-court-btn" data-court-id="2">
                <div class="court-center-label">A2</div>
                <div class="court-lines-wrapper v-wrapper">
                    <div class="v-baseline-top"></div>
                    <div class="v-kitchen-top"></div>
                    <div class="v-kitchen-bottom"></div>
                    <div class="v-baseline-bottom"></div>
                </div>
            </button>
        </div>

        <div>
            <button type="button" class="court-interactive-trigger h-court dynamic-court-btn" data-court-id="3">
                <div class="court-center-label">B1</div>
                <div class="court-lines-wrapper h-wrapper">
                    <div class="h-baseline-left"></div>
                    <div class="h-kitchen-left"></div>
                    <div class="h-kitchen-right"></div>
                    <div class="h-baseline-right"></div>
                </div>
            </button>
        </div>

    </div>
</div>