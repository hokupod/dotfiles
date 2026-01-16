api.mapkey('ga', 'Discussion with Kagi', () => {
    const currentUrl = window.location.href;
    const summarizerUrl = `https://kagi.com/summarizer/index.html?target_language=JA&summary=takeaway&url=${encodeURIComponent(currentUrl)}`;
    const query = `下記のURLのページを確認し、小見出しと箇条書きを活用してキーセンテンスを作成ください。
この後内容についてディスカッションしましょう。
${currentUrl}

## 注意事項
WEBページにアクセス出来ない場合もあります。
その場合は「WEBページにアクセス出来ませんでした」と返答する決まりとなっています`;
    const assistantUrl = `https://kagi.com/assistant?q=${encodeURIComponent(query)}&profile=summarizer&internet=true`;
    // const assistantUrl = `https://gemini.google.com/app?query=${encodeURIComponent(query)}`;

    // 順序が大事。最後に開くタブがアクティブのタブになる。
    api.tabOpenLink(summarizerUrl);
    api.tabOpenLink(assistantUrl);
});

api.mapkey('gt', 'Translate Document with Kagi', () => {
    const query = window.location.href;
    const url = "https://translate.kagi.com/Japanese/" + encodeURIComponent(query);
    api.tabOpenLink(url);
});

// gd: github.com の URL を deepwiki.com に置き換えて開く
api.mapkey('gd', 'Open in DeepWiki (from GitHub)', () => {
    try {
        const currentUrl = new URL(window.location.href);

        // 現在のページのドメインが 'github.com' の場合のみ動作
        if (currentUrl.hostname === 'github.com') {
            // ホスト名（ドメイン）を 'deepwiki.com' に変更
            currentUrl.hostname = 'deepwiki.com';

            // 変更後の URL を新しいタブで開く
            api.tabOpenLink(currentUrl.href);
        } else {
            // github.com 以外で実行しようとした場合、視覚的なフィードバックを表示
            api.visualbell('This mapping only works on github.com');
        }
    } catch (e) {
        // URLの処理中にエラーが発生した場合
        console.error('Error in gd mapkey (GitHub to DeepWiki):', e);
        api.visualbell('Error processing URL');
    }
});

// gc: github.com の URL を codewiki.google に置き換えて開く
api.mapkey('gc', 'Open in Google CodeWiki', () => {
    try {
        const currentUrl = new URL(window.location.href);

        // 現在のページのドメインが 'github.com' の場合のみ動作
        if (currentUrl.hostname === 'github.com') {
            // パスを分解して組織名とリポジトリ名のみを抽出
            // pathname例: /org/repo/blob/master/file.js -> ["", "org", "repo", ...]
            const pathParts = currentUrl.pathname.split('/');

            // 少なくとも /org/repo の構造があるか確認 (index 0は空文字)
            if (pathParts.length >= 3) {
                const org = pathParts[1];
                const repo = pathParts[2];

                // CodeWikiのURL形式を作成: https://codewiki.google/github.com/{org}/{repo}
                const codeWikiUrl = `https://codewiki.google/github.com/${org}/${repo}`;

                // 新しいタブで開く
                api.tabOpenLink(codeWikiUrl);
            } else {
                api.visualbell('Not a valid repository path');
            }
        } else {
            // github.com 以外で実行しようとした場合、視覚的なフィードバックを表示
            api.visualbell('This mapping only works on github.com');
        }
    } catch (e) {
        // URLの処理中にエラーが発生した場合
        console.error('Error in gc mapkey (GitHub to CodeWiki):', e);
        api.visualbell('Error processing URL');
    }
});

// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;
// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>
