local git = require("csc.git")
local parser = require("csc.parser")

--- @class csc.BlinkCmpSource : blink.cmp.Source
local source = {}

source.config = { trigger_characters = { "(" } }

function source.new()
    return setmetatable({}, { __index = source })
end

function source:get_trigger_characters()
    return source.config.trigger_characters
end

function source:get_completions(_, callback)
    local scope_context = parser.get_scope_edit_context()

    if not scope_context or not scope_context.in_scope_parentheses then
        callback()
        return
    end

    local current_input = scope_context.partial_scope or ""

    parser.get_scope_suggestions({
        current_input = current_input,
        max_suggestions = 15,
    }, function(err, suggestions)
        if err then
            if self.logger then
                self.logger.log("Completion error:", err)
            end
            callback()
            return
        end

        local items = {}
        for _, suggestion in ipairs(suggestions) do
            table.insert(items, {
                label = suggestion.label,
                kind = require("blink.cmp.types").CompletionItemKind.Text,
                detail = suggestion.detail,
                documentation = {
                    kind = "markdown",
                    value = string.format(
                        "**%s**\n\n%s\n\nFrequency: %.1f%% (%d uses)",
                        suggestion.label,
                        "Scope from commit history",
                        suggestion.frequency * 100,
                        suggestion.count
                    ),
                },
                insertText = suggestion.label,
                filterText = suggestion.label,
                sortText = string.format(
                    "%04d_%s",
                    1000 - suggestion.count,
                    suggestion.label
                ),
            })
        end

        callback({
            is_incomplete_forward = false,
            is_incomplete_backward = true,
            items = items,
        })
    end)
end

function source.set_logger(logger)
    source.logger = logger
end

return source
