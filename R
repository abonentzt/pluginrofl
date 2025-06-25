(function(){
    function parseEntries(html){
        let doc = new DOMParser().parseFromString(html, 'text/html');
        let items = [];
        doc.querySelectorAll('.result__item').forEach(el => {
            let title = el.querySelector('.result__title').textContent;
            let link = el.querySelector('.result__download a')?.href;
            let seeds = parseInt(el.querySelector('.result__seeders').textContent) || 0;
            let qualityMatch = title.match(/\b(4K|2160p|1080p|720p)\b/i);
            let qual = qualityMatch ? qualityMatch[1].toUpperCase() : 'SD';
            let hasUkr = /\bukr|\bУкраїн|Ukrainian/i.test(title);
            if(link && hasUkr && ['4K','1080P','720P'].includes(qual) && seeds > 2){
                items.push({title, qual, seeds, url: link});
            }
        });
        // сортування: 4K → 1080p → 720p, і більше сидів зверху
        let qorder = { '4K': 1, '1080P': 2, '720P': 3 };
        items.sort((a,b) => {
            if(qorder[a.qual] !== qorder[b.qual]) return qorder[a.qual] - qorder[b.qual];
            return b.seeds - a.seeds;
        });
        return items;
    }

    if(window.plugins) window.plugins.push({
        type: 'video',
        name: 'Torlook UKR 4K→720p',
        version: '1.0',
        onSearch: function(query, callback){
            fetch('https://torlook.info/search?query=' + encodeURIComponent(query))
                .then(r => r.text())
                .then(html => {
                    let items = parseEntries(html);
                    let result = items.map(i => ({
                        title: `[${i.qual}] ${i.title} (${i.seeds} сид)`,
                        url: i.url,
                        info: `${i.qual} • сидів: ${i.seeds}`
                    }));
                    callback(result);
                }).catch(err => {
                    console.error(err);
                    callback([]);
                });
        }
    });
})();
