local times = 1

LM.observe_notification("buttonClicked",
    function(userinfo)
        LM.post_notification("setLabelText", {text = times})
        times = times + 1
        for key, val in pairs(userinfo) do
            print(key, val)
        end
    end)

LM.observe_notification("setLabelText",
    function()
        print("Heard that")
    end)
