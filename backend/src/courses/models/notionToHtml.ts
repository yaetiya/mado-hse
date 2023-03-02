const NotionPageToHtml = require('notion-page-to-html');

export const notionToHtml = {
    //Explorer-45c0745ee88f4c1788c1c3b6ea0826d5
    getHtml: async (pageId: string) => {
        const { title, icon, cover, html } = await NotionPageToHtml.convert("https://www.notion.so/" + pageId, {
            bodyContentOnly: true
        });

        return { title, html };
    }
}