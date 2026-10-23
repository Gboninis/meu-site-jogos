window.EJS_player = {
    gameUrl: new URLSearchParams(window.location.search).get('game'),
    coreUrl: new URLSearchParams(window.location.search).get('core'),
    divId: 'game',
    dataPath: '/emulator/data/' // <--- ISSO AQUI FORÇA O MOTOR A ACHAR A PASTA
};

function loadEngine() {
    console.log("Iniciando carregamento forçado...");
    const script = document.createElement('script');
    script.src = '/emulator/emulator.min.js';
    script.async = false; 
    script.onload = () => {
        console.log("Motor carregado. Tentando instanciar...");
        if (window.EmulatorJS) {
            try {
                window.EmulatorJS = new EmulatorJS();
            } catch (e) {
                console.error("Erro ao criar instância: ", e);
            }
        }
    };
    document.body.appendChild(script);
}

window.onload = loadEngine;
