local debug_getinfo = debug.getinfo

lib = setmetatable({
    name = 'utilities',
    context = IsDuplicityVersion() and 'server' or 'client',
}, {
    __newindex = function(self, name, fn)
        rawset(self, name, fn)

        if debug_getinfo(2, 'S').short_src:find('@utilities/resource') then
            exports(name, fn)
        end
    end
})

cache = {
    resource = lib.name,
    game = GetGameName(),
}

if not LoadResourceFile(lib.name, 'web/build/index.html') then
    local err = '^1Unable to load UI. Build utilities or download the latest release.\n	^3https://github.com/overextended/utilities/releases/latest/download/utilities.zip^0'
    function lib.hasLoaded() return err end

    error(err)
end

function lib.hasLoaded() return true end
