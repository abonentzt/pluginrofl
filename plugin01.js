(function(){
    if(window.plugins) window.plugins.push({
        type: 'video',
        name: '🧪 Тестовий плагін',
        version: '1.0',
        onSearch: function(query, callback){
            callback([
                {
                    title: 'Тестовий фільм 4K 🇺🇦',
                    url: 'magnet:?xt=urn:btih:TEST1234567890',
                    quality: '4K',
                    info: 'Симуляція відповіді'
                }
            ]);
        }
    });
})();
