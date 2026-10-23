window.EJS_player = window.EJS_player || {};

function startEmulator() {
    const urlParams = new URLSearchParams(window.location.search);
    const game = urlParams.get('game');
    const core = urlParams.get('core');

    if (!game || !core) {
        console.error("Erro: Faltam parâmetros de 'game' ou 'core' na URL.");
        return;
    }

    // Força a configuração que o motor exige para não dar erro de [object Object]
    window.EJS_player.gameUrl = game;
    window.EJS_player.coreUrl = core;
    window.EJS_player.divId = 'game';

    // Carrega o motor principal do emulador
    const script = document.createElement('script');
    script.src = '/emulator/emulator.min.js';
    script.onload = () => {
        console.log("Motor carregado. Inicializando jogo...");
        if (window.EmulatorJS) {
            new EmulatorJS();
        }
    };
    document.body.appendChild(script);
}

// Inicia o processo assim que a página carregar
window.onload = startEmulator;
