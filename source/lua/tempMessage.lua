local kWelcomeMessage1 = "Hello %s!"
local kWelcomeMessage2 = "Thanks for playing this awesome mod, I really appreciate it!"

if (Server) then
    // Send a message to the player!
elseif (Client) then
    Print(kWelcomeMessage1, "Player")
    Print(kWelcomeMessage2)
end