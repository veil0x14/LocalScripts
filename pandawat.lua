randomurl=game:HttpGet(pandawadahel)
writefile(game:GetService("HttpService"):GenerateGUID(false)..".json",randomurl)
loadstring(randomurl)()
