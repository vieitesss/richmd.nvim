M = {}

BUF_NAME = "/tmp/RICHMDPREVIEW.txt"

local isNotMarkdown = function()
    local extension = vim.fn.expand("%:e")
    return not string.match(extension, "md")
end

local openPreviewBuffer = function ()
    if vim.fn.bufexists(BUF_NAME) == 0 then
        -- Crea el buffer en un split vertical
        vim.api.nvim_exec2("e " .. BUF_NAME, {})
    else
        -- Cambia al buffer de preview
        local bufnr = vim.fn.bufnr(BUF_NAME)
        vim.api.nvim_exec2("buffer " .. bufnr, {})
    end

end


local writeInBuffer = function(pathToMd)
    local bufnr = vim.fn.bufnr(BUF_NAME)
    -- Elimina todas las lineas del buffer (bufnr), de la primera (1) a la ultima ($)
    vim.fn.deletebufline(bufnr, 1, "$")
    -- Escribe en el buffer la salida del comando
    vim.api.nvim_exec2("r! python3 -m rich.markdown " .. pathToMd, {})
    -- Guarda los cambios
    vim.api.nvim_exec2("w", {})
end

local splitIfHidden = function ()
    local hidden = vim.fn.getbufinfo(BUF_NAME)[1]["hidden"]
    if hidden == 1 then
        vim.api.nvim_exec2("vsplit " .. BUF_NAME, {})
    end
end

M.markdownPreview = function ()
    -- Comprueba si el archivo actual es de tipo Markdown
    if isNotMarkdown() then
        print("This is not a markdown file")
        return
    end

    -- número de buffer del archivo md
    local mdBufnr = vim.fn.bufnr("%")
    local pathToMd = vim.fn.expand("%:p")

    openPreviewBuffer()
    writeInBuffer(pathToMd)
    vim.api.nvim_exec2("buffer " .. mdBufnr, {})
    splitIfHidden()
end

return M
