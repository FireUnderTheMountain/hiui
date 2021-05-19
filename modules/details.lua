--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Details", 0
local mod = Hiui:NewModule(name, "AceEvent-3.0")
mod.modName, mod.version = name, version

local Details
local primaryWindow

--[[    Database Access
    Store all of this module's variables under "global", "profile", or "char" respectively. These are shortcuts to their long forms:
    mod.db.global
    mod.db.profile
    mod.db.char
--]]
local global, profile, char

--[[    Default Values
    You should include at least the following:
    defaults.global.debug = false
    defaults.profile.enabled = false
    defaults.char.initialized = false
--]]
local defaults = {
    global = {
        debug = true, -- noisy debugging
    },
    profile = {
        enabled = false, -- have root addon enable?
        handle_combat = true,
        skin_import_string=[[TI16UTTos4hNT7psGUzl7Fg3SUnaP2BJ8zploWqmus02evMuGIQj5SNMN9DgsQBo38cSaPUsIuZmCU8nFJs9t3KMuFq(aPwt1n1zuvAwAsEjp)h6dkzZ(dKh4Ic5d4JpYeneQi)GubV3kF4VPPRcsxDH)mqm8cgENonjBprLUY7s4PhGNsKnAIChjxEmJQnkqwkvKSgTwkQBLLruWVHMFJWFbzPLYsWSi8CPGSJxYstUrOzQD0C22RkkwlQ3Entt5L1B5hP7z1Bh(k1Kas9bkEcsQ)bxqYBQ1YJPjPj7KcDTwXf7RHdzH(aO6jwfQ5vONrqOz8sUMZQrZcUNjyhD3b2w9dCD(bcTSKOKLSAck)(d5qVOZMmMeUOc85CXojQgn7r9DOtQKlyPla5wXYpZZQzR2dQqQoslTI72HIdFqJIroW3FOe(NEOyxQ4mrr9sf9iB7VDZfU7VLxRV4R9VG1gnPkfun1gZwGHSfOZyb6oQyQCMqt0pvXWLt2XFKvqWxLyI4VAKg9JvGLGEcLrzR8stkz7SxKX0pWyc8AD)rjJM)J9GNvuqYlP11o5NDYPNuFedodvUNr5EgL71NMHjde0H487lXKJTlV7M)47BiKl3SzjykGslustQbtqZkzfTAeSP0exO557xqvlKQcM657dCj7VFsEn)pzdne39EThhTIkQHerJVe15bM1tf417toVegSWO37LM0udEPUKimD5OSGvIvLjnvqiLyUpnbcVLGyUkNxSqXO6deyDM6lki6C53GZzP8H(D)7svzX2)X)(FE1QKBwVYly71RxF9vxNS9ZYYcQsr3(513E9v3D3v3U(Z)wYLhdA1hTS6afHpM0kZboB7d62IF7l1VfWh()awHj7bQCnjkU3CVI(uDofE9U8jlQH19N8FWka)FD5Z3BUk8xM)l4xTvjzkW)YGn(P(GtpSJvGw7DKCZgwWyEN(eNLt8MnnYFwKxW044GPtt3DXKjyY0YOjb(bt9M5fegppEEOBLW0LZIIJdNg55ffnnW3BoUY0biRgdXuslAoMXuTyf39Aw3ItWPCESUh)(EONV)VCx36MgxXSSKILbAQstO7GqMjDCi41Gk(ZorpIOy)KPQzDgzpwHjv3Lh53fMpz9xQ8b281)nEUU54Z3)jNw(7VQl6CqFes75nZLbk3TRgsGg)o6tZpgccoivzAyqqSN30jHHbXZN7HH9qtQYBSs4BUsuREBrhbGrf)pF((V3qluq08573Szqs(q33RJfJE1D0AnPQM0ubjeDfzq3fwffekCqs(RtRCErq3uNVh65XihrTI5XizduCvLn75qhX9yx2cUILR5G3fJZgomwOUx0cdoUWptWFMIIX2wcUoXXGWaUuWQbQsGDcrcuAgitEUscAQUQeGoiTuHsSCNiwWeu9g6qDP2oEkDBh4nT3XBQ3ohHhc7iZTdh5Jdmq2QbmpEJESFeyIHj3BTs4BUsBgILNhAecdeGrrJ7tYf2Ar4YFslBmn4W3f07hTrZ2chUTf9BBXPYl6Cv8K3qIVyJtpxjg)Hs0STzNRINFUkg4kCU78SJl(bN9odp7DE2bh)jN5o1wM9PjFJlaS)sG5kphXSkbYca7Eumyz27sbDqW4d5RQpP4B02cD)PhpGbk0G2HNwf7HhhODNaiCAhdA8Gvxee7uQDCQHyaNk2OoX61oJMz3J9EsrjJ(tlkKf3e8j1TDCaiwjE2LcgIW2QyyheJBxBfI7yd29pgpRZP2uyNnHJubRGZmKC76F)KXI4cRmaR7jZKpMzrbSeJXzWi10scox6loopHMa2)RYucHGQd6pCZNxVkz7nR(xe44YljBaRHF89yJR7WX6oAD(9raYTS1F58FwQlpWRmzPL8m3WZGT)u6Y4jZcMGONZJG(TZri0O40Khtxcm2Mh7fnnEQFyq0KOi3svsUamQfR3Sz93U7MV8vCC92Mjwct2P27MLS3GLqyd6g9)Di)xZn1nXNjJ502Ub9JorEj1VV44v5CMfuK(MzuoAJwsmAY0NDJBQWfTZjMnOs09AJZkr7WKrrrGbJXGUibMhSKcnDtKv4trUaMJfvd5Wq9iJ4AInmLRJeq3N64JGk643nMCSag12Xc(DivngpWFMdDr7ks08JwV0RpjHr4UevZ3KX4mZBukOa30YeWsnrNqxuRwcCVhtwAuPk4mnWfJd94tG5LYWE)Ay04wgSdyjz(0rJjivkHbKml8au8urRmGOJtzFZpie7XCjmD9i2X(dyu7Dz8qe9SoxzIzep3OZlHbMM4fmBMF8my8iB140(cieP1(vHwgnpE2K5(ZI9JNpjWZuCgzl)umm5ZHGBtla)ggGtt(kVHpcYenfCC7JnLAozaK5jFCncKMjE5xydZqt)V)]],
        profile_import_string = [[fZt2YTnss(TSX(W6oIXAX9XoX(aPfPTglrQHGQ90B4qqGeGKieiaxaqjRENwF7BEuvHdEynoMP7i62IeSQSYkR8oZc3RF)87d2vwSknlb)y1MINdJktYJcllYsctxwKF)I7dwgTREFzsyzsugoUn4FhcJFxsw2YOQA8lBtRwghvhHFoAFj93K8KY1VGFkoAB06e4t13hucRYQOya(5a0MOFFa8Hjg3pr7cd833Lf9sszyCsDuAwv4ZP5Xfpt43YiarXjSiQmSo5BiwDFqWJVKLMdFO6raqbJYE6URq4KVFBszkmNWQxQQt2sZCFfSpWTzE62O60I8ke9kt2vuwhIBSqawpwHB7YKTfpX76THRkl2gMhTnH3RWS3Vne(5YOSSWLfBxevhwNUfrpny7MevVjSUOiRoDhSdIR3C)etBn1kvxe(8MI7daIBwuvviqkxwbWPOmUcjkogmPbPj26(2M6g2cAKPl8jt8t0ZS4XaB4joMQjrdIg(PgSbGnIrlgjnct67wYVtduxb2gS4uJTnE3hH7p2g01tGU6hFGwNctpYUY(mi7HumNZnA1GXDabCx1WLd25mJ2tnAhtdVMfW90tXxnf1bO3PhUJ2POGhmwBx3ZCYCHC0ocYyl(VJqyO5zXZdHTN(zy8oa0wNzW9GSHJ9zO4hm4MttNdj2hmA3ZrRpy0ENd2hWg64FYtMdgRR25qK(dV1OpTMH(N(6AgNMO3vAZv)KyEpAIUM5PpC6buJtkb3J9qxZ6me6Eq18CmPhW3zEobGd2B2N5qPN(jh9tU76Zgz7CgM)(NAnm)ha3dgQ1zKt6XcvRm6hwfbg42vq2afwReg4JblWv1r17RaBTn4SKUj3Ec46bkbatMtCW)X9(GVuuMfhatp51hcwwawPHfDvrE9YISIYWY01BQfavxEe3I0QJdhTPdwKPHor3vHGHBJ(wyDu56K6kCUbOBkHvP)k5dZx4X(j6p1DN0o5mIYxUbrJKmWfGNsWrTdE6IfLjpLsEf0AyjXG1AY3b2)OTf7ZRr)deuj0pKqAF1Bh5R760FtH0acvNOBGUXS8X1La8IByK9DKh2(oYZp8tc6maJQ9l2MKVp8zW1JDr7skXtpjGbNqQZeEHqeMfGlfmwsExG0OHe2zOJ8ZbxJFrZLmpfmV9xM1AyWYco5SnkNCpPhDnArAwADAsfYaqyYQOLavDCz6V(6d)19rXLGJHV(WCyTfOtB6LG7UpPQbXz38UK9h81hggvoK(TxFWuDwwSAvvsDpicqbWV0TiDzBs9MIy6CKOvBIqVkxOwhXPIfmfG4wfUyDZsFvEDsjUN(AWTJU(6HtN(5VgGo)UOO4X3Fl4z771vys1YYKKCsQIXgBnxK7gWO3dUaskcKJDxrAoTvRRl22ALBCeu)(X22EAw2gMEgAEgMww3V69Ghra8g7zAawinmS88aEetn8xirZXUoUw6Mw6UUM2o6(M4VqkbgBRbUnO7Az7RzyA66ZqRT4zh2yw3VEZXslCS1riQbWq8xtXFTKE0JkCQc7kEbNCpJkjK(oNwfwxgvTb5L390UWOQquYyh(DKkVnQ8rwutCqreCHp8O7ZGyk4woaJNsYWf2c4GHVT8XWuW3)WSe85OGcg5bnEs0cgfhGr1zJjjnhugMVmPkKe9wMLcagCIVyxcfIKksGSei0K8KNxUb(AsofZtagyqy9l7si1kyus0aZ3VlmRyDXEsDsZseNwfTa0oJr5Sb0)Lr6ahs7NQnaflFjOznh(Fk6msL6IxerUvNeTLIbRlXbO4ajxc5Q6YK6LB4OAqrzuj)IMFpRa2E7ZPtGWf7bUtooPTqirLVewclbAYrnEMeYNy0aB2mv73TRmPsE8oXrRZVMSgiO1v0kcyjm1IDuyzhlUV6JCMh9n5zUjf3vmqrHy42MIwnCAVw5fWZxia7cMHpeLQrbnMV(O6SqDF0XQGGWOjDkUOS4rHoQ7d()I3v9BV(a8VWe2xcNg1HWxqnpjOGceomsSIvR9BqAJptLtuONpuO8kyY0jJKpILk8GnYl1BsxggdyBcqMAn3QOT7WdFAO2Tiahxv9QsmCxzEby7kaQd8oyy(bxp9lSfS4YIDFhf6cPiXHmz7KTR7qYFu4XggKc797aklkhceTNIYyVmumfsCQUJqjVUaMgku7gKxuULtwXlOAx0C23UFSJLNVMgOU00xZZrZd09zHkIa9LAMoEUo2G2uBnnl6xG5GOLgHwvW(taodewOkINHDi8RnJQwqRACCAiY7a6kQ3aCoR3e2W9r6ryZaswa2Y)7XdXQ0yszbACyDyjRrnyd80qqDbyTtO3SLcaHu6zzNeI6uMDcP0(0Y22G44P5vFvyN9RPygBQ(A7PufAO49WKTeUCFfz4sytTUmnFDvt(oWdKNbn5Owsbl4ZPOEhuvjMIPQqein7K2KkXctRlLogGWMMVIofqbUziLGs8dNkQLVXnenuE3i4siWDDBW1b(HvWGYKp(6dFm4c2suyN1WJoyK(n0RXJ7yO8qbzw2HcFW(HDigewcYswXFyrs9ZGFec3yeUIe24XyiN4ig(hh3ElEzP0biOEJXZXVoE2v)p)15HHxmF(yjO5ZALUoqhG(VDXRpqFY83O)y8BD1gPjNlOYiVc8rKN9IM9JaO9p5AgWB7mfzqB5mTs9cOsjyBrCsgPuaSebkRPVFFa5)w1xhSmnEyjLUo43tk)i682f3yGkREUz0uanFD0F72btcUA6enJVE50Pxo4YGV(HIS4OYYOV(HPxF5GzZgC90pCxWfBnKRxu2UnrCGzcy2Yoa)a1q0LtQzi1c)4FBecIPaTRs8M8mxxg9cBcDrJc7E2JehycLjFhLiNZJCd5iMbghH1c8jp4DYNWlyhojLWgP4KsGmT4dX1EiU0uoJBKOiUMgKe8N1ZXs3ZcCR11ftbe7Pl4Dm4ZSo4RRh4NRRVRYhyW7yplWVyhlqrVLJHUg5dSt3n41mcLVF7IeL8vdhlQYt(Kgx0AD8agutGGLgJ2R(6Dx9EX3VoTQ(9FQzc8E)8IwV(WFx8zu(6qQ)yik2(uO26jArSCGagC10CSnnnC99LbmyCYFX8K)I1P1m9JjZEiGoypEe1YVfDCcICJ(YQgfM9FQquuhDHqvaesm6urycg7lRdJwb7wEcd)UEwP4LAV4lKO0rKsqpgJQQdbVjz)JKJgKBs2fbqgObb)DU8gng4yzhHnxWvPhXPTlB)AWZj0zDqGlTmzjhrMUWNeEMhiecuZHOxJd5S8iSDHb8RcLUgDaVcC9bWh01CaAC1swwwGb1Gf2bunjCTre3vytvDi3BKKqPFhQHd(bTw4hudE2r7kmIfIrO8l9qXLpk4T(EkriVXo1VyEYFrkxW(QHE3KthHsxuBP0nnhIASIolbpD3twm1O0e(DhinmZ2dByZWg2hEwV1f2(eq8Gb68wHO73fI0W8ERlS)BDH11EZJ8nFUOB8MhP5BEKV5dhD734iRLLc9gSoLrzGnN0LOsPmWDdWd9E0Auk7SUP(DDKTrjdwb1KUdZu8F1DdsabQHmaiSQgTLQvUJ0FgMQzGrxeqXzbEFee9ucLAt0pCy9dUC08bxDDqyW8bZVly4GzH3E9DF8QjH3E5Tbs)Tp9O(a4e3NvrDIa(8aegqA1NsJJtYL57zUmyGTrFlG1XEvCfhIUiRhZLzec3zJpR1IF5grUlXV83OVyi8UEa4krUcmbiLBSRULJJUUVMTp4FJbMYqlFEaF476G35im3gm6J3mAY8o74f)y7yEB8ERJSdppXqSJ1)DzhZSc)ZA7o2XwZeWstxDBnn4JOvd9FukG5)ePa1IypFdN9Q0CaM4aLhCc)wdbtNeULAMb4hrZFTZQPi)eDZ4X7nCfydasuxMm1W9f7TuI9AyofAswiNffYhGU6glYznbuQCrDkG)en4jH10OYsavhQSJuhLfY17QlSYEbtuHkH0KpkTCW9QpmDsWxVAYphcWpnlCoGQPBpxWu1TQHcLVQ2frXe)EsEYwX3QpsEty)nFoD3H5KRtwusZ50RG7be1ddRYJ2X1WrauU3CO8)YEGjtjJY5kSJEQlcPFL8QBUGzzOuvk58xph9AY2xtAx5mOztPJde9bilkbYWPZNp9Mzx9Xp1lHVQCPPs(tdwHzDhwQ)P7exnNZ3wKrWxzIHHjF)m(XOAGbf4Qtcf(31jEAv5Lu(V2U4fgygIBhZh2zrIG7otCdDfE09e2x)(MOvHcD8ylej4DlXeit4qlx5pcRHkxxRlJwG(5ILqDrp)aALDVt4Abkigs(XiwgIrtK9CHZjGcfSLP6gQsxE3UPreIdODybDXCkeOIQ0Lrf)HMOyAJ1pgmJo5foeyHYpm5WWKBk9Bx2Uwv5Tjk1Unvfvv8ocoNS2dm3waLjjrg1g7Pb7BdppDxplhdFuGXYPrM8cv(8hB576z7R75Q76BBOr2JSyjAU4tclcSaIUu26tT4IWqw7EYHX3UDpO1mSLjcz2H56ZllqePQihvdpocwHwoZvln4jAgpmBcvufrqWdRuDwIivgvjLaPkecXUItdefGnOMdOjloUB2iTTmLlYywwAC7gmSA5MKTC6foOIHqi8R3iAMYU)ytncfHmVmlA7oPAaVwj9WGp(EVUfRpMBtXoTNOnDGgYnzzfw0qHDnk)7f7JdfT7ztBBcNdpMawKaKcRTeeabU1jIGS4IaJlSfK1bu2mgQU3W2tvMhtDsmz5geJavhjBxWUU3In(fzYwqL8FR9xWzqDHzaQznFTQ2JY0pW1)dq1CSxpmnAOLRYIwZLee2M4P4M0KS4kEFZ5Hru09GpD3K5JM1R5BoS3BOk5)LbZMD10tn429DtqWNgCZGjh2fsw(oA(hP5TOjDZGpo67nLoRYTJM)DxcrxjrI5xo7URUSPzNS4g(q0clEEIgx8GL5MPt(8b9CKRz7XRAblUbsUC0G5F6Ztit8hGGhFkWIeCMtI2BJ7M85jG3phGrhBS3o7QrbnirdXXOdj4iNgZM(X7g9MMyhI1aqra6f8BBjBJQJMm6MF5TS)VCeqS6Y4kpoC60fFDPWFcZB)B60VlfCW1dU8QjNcX6Ug3n5JZME3T3E9GFPfYD2tiqQse31BaX6Cev3RHoqnNChDGFQvlDi7Dbq3GYL1MYZcb69cOUMIPjPQcZynzGL6adYjfU9WrTKBkQHbMJncqXoYV45SxhSsjvpoqtdugvXoeYk3b)N2TbSBmug)XrAdTUT8ay0Bn4ZJSThSBQoo3VgjXPKrKM1LAznSDvQOGDq3UjBduGaq4nC7S8mPsUiUGIaPmkoDpgoRJipdnU8jM7TfvCv7fUTIEsrzLK37d723mI(MdrxSNXoHLclSh5fwkS80yD6RIal(nTCe2IA(w6I4YWMfAvz0AYmB)(BHDXG8jSSikgVRcDR)wNmWFGM)lCCLT1KSJhToMs)lCLT)KJukZY8iIjxOAUpBftV5bk5T071lv(K18bZgnzq4Vm66RvQ5073Y3NuyZsAhqIE918RRmuigHMvFT8D1I4Fkv6UUQUvvIyMn4)hNnA0ez1O090T0b5yWTBthdJwvJY3Wu3tZbC22YsZ2v0YBMhxxVHsSwSEhOJ)G4oARhx1VMY(T0s)qR1sYJKa65Em1u2s(aBjDY1)ukNDSun6zNXQYdcWHpz0DZNn46JDCFGXbGnrx3TDfWUqt25O69DmWSh)GqZjkSghvc(9Io2UOLoKDGwOLu1WXh3)Q1a)z7IISko(n2fFWlnmVY5RsPeoVIL94Yxr6s)F3JADItQfr)qx5gWrpUawlJaFLP1QieJLSUs6)FJ(WOLl5M6tk33T3Ny1VQRB0jTeCGR4lkQi1jKBKHuxe(d3bxDBJzhXd628Ksoq1veq2C3Qo040D8L2puFCn8n1hxxORAgzvVilBfzl3J3rxuGUYw6YwtrcoSqCbjqq(P1VCIU7s0RH1BaMInfzXIedwUe4aagMNGzsH0GwaA6moGO0QD(WmT00tzCSkJTT0Sm19DDCT9Hiy1zLlkEiMhuy5q1iLTJ6JnAiQub3Of)d2xg9mnZMKBzORD40QMhnSam8NMJ9ehTRwNvSi6sUJje34SYKLr76vEhovTIfuLTNS0vaLJBCjwYll5jkrTCyI0PRi8prOEK7ludVIPaD7wwpf1v9ycGWeFqHvsX7UhJAN8SmGDCzjeXhivgFFWR)L3)(xFagXRp88Me4FR3K86dCaPV(apmG9iTg(hCIee(1I8KEq4Ctgh(Fc)Xu4liIadpnlJwwcEGlm1saX)EDrhKsCa(Vbicm0ui8EGZca5U91V(WgG1vbxqJZMxFaDgP1IGpyzcdFglIYQk6mG6w4pFFmG1QsUjIF9VGZgzObyTsmq6y(1hGyCreMsFmIGIF9s8xbii8N91hENGN61hmT1(Px)lIn1fh5(j(6d)30O(Z86YebeYulOcOaqEBNAK)eImssufG851ibGZCdtnLIPW3aEkaBwxGNnOUgEaesdI2W0sQRHW5rQgS7sIEc(cTcc0VUCFsl8)eQbO9aouXMGe4Br9webBIMB(zh6JzlW3ZJBM0ykaQsHKypWEJdBHSINzYeAQJyDXP2SeOZJNErA6EDA5WblwqWmBgVwSESoBbj4(VMLScXRbYFA8(CYSA17(jbCa3Ur(p0VB8e7xrbKy6ePmbSfJC0W58)jOjaCvMxWNlkFS9waCj)1haOy1HBQN)8x0WpbJ)pF6XXMm4bQy8al8ItlbJh2q7OSwgsAJQe)iPqv943DkgLJ0C89zsAwqSYkap)YI8wYusvleVJuQaZzjEmOqYgeyfiN3gdo2LQMqbAGcCydEKSDpj4qIk0slpUFoQmNeoqTdi8YBVG6Tpkew6eZGemk2ZKyDT)mP5JcsK1Xiva2wnjOAQ6O6wP6PXm4urZiUfo1HiyPNjsu7)iGval5mPowhwOFairZRIp6etNYXlE9TREjNcXw2x(jFBxyzuAmSylrlWju4FtmS0OgEYWs3t8xX31OoFYW0Zu8Dh(7((IV7kgVR45EIMVI85cdSFtATWEk2mzGlNpMksImNN4qU0KXCT5Y3TS)Je5q(z04deEYGFHUQ8I7waUnj1G4noOL1)ozWvv)iS6eAu1j0KvOYvsSuqrCp8fUEo84)AlpIp6KPst7zabIyBy76yR57BRjknDhCRPYyDGZrUyDuH761CNgnDLO(bBKoB73RB0DJBDW4BqLUy4zjeNkuGw9HyhO9gg)XwM27LXEM(6yyYE2w6AMujwaIawalpDDtxnpicBG0dKkHpUT2XDtTFddtxkHClxlQmh6(hgHKkvz01k5PK4pqvuKBQAzVUj2xaDCWE0AcMOmYl(Jv58VKeTdemgcIlAUYMGtqtaimk)P0YIC0jwq53yWKiOF7Nok0iKi8MO1qKGJrhDskXXl7yo6k5b8Hui9bbG4F5A8AQcgYFeDs52nVGvhm7N4L2012u1eDIa7oaFUecYm)Ki0aQ0(VegSF1Qc8QBjB1ocvo62RoDnyh7mBVbLlJGOQUbofUHIS(fzB5Ha15yafSW)tNK8hShDOFCsvDioWGDPLP1Yg4dbP7ra51rpfD(T8SnVuaFyt4pxKbiCHSx)qi6DeicXkUn58G8dy36JDp7TfPvahJMHSVajYPVJjd4XLfv1lkqtKV7M0Ys0W1vippFWQBA7z5O6uq6K1x3JpD)uXZzKf3HzKVCV7Mi0QYC6wh3mFttv)dsZ3YYHy5dUo9jE6Gziy2G1MScmyjjpLdFzN4gkKetC9m4MHjyyu5Jv7WsscZCEzA(JnlPLLPVQ9cP55457Z73pdSczOhNbf7Z6pvhBDnFtv)gskD8D858fbOl5hMYp5BIkRFbDR6YOoemFtpvJisGWqZvSJ)ywukAhFEb6w27KF9F3qozdtwms3Pzl7PBiw)I8)dQ1CHJ7(OULJLUfpvx1u18euRVKS4z0dIsC(8o)JjB7ddqkgc5NGHK7dmF4cetIfChOwCB6YtCo7O5W8j(QL33HZExWWSIIyiaNHu0B9pUC0eQYKCyaE44PDCwSbfJ6ZzzO0IQd81hGSTMHehnAXqbNxn44Rp8PO6skGKEiPHU4TjIzZu15RqbCWaEjwsO5T4nvH5r(Brz)Au63oGiJwHyqzPaLUUodQRwJHrJ((cAMtWtRXKN39qhDDFFtMOzRac2cbsUS4uSz3X5FtsmAgabzFeXaF7EqVAgKAV08oPc)aYixF19gnmBEygOX5ckXanZ4jTGMosky3hfSn90yMwdVwBdp7d3gdJIxFeEhBpplA(kUodphl5jkecn5x)NtXyPF3TqWqG8MyTDTS5JutnLGQoieDwbv9(cQMsMpFllxHz86I8eHM6LG9HgZKe(sKCtJ27x3d3VJ2cUAS9i8HMu7HG3t5waq)qaCfe(fWmfDe1J2AKqUPvlDmomU)HnuMxu64MT)iAyrohxE33W9PBjaXSI6LLGFoOu0pdN)fGpnxwKDGYwDxDhpMb0SrBNMpxS7GVG(SxTJo)6nrhFpxXwOH9txZLPcFOiNY0eSfUmcdm)lqyr7OyE6bhlFG7H3hET3h2)W7djxOPPlxSlq3WQKfGyaEuIIdBvNcgAKUilj3NNhOUMTjNI9EjTsNWKmLW2jw6T9mo4MKSKKt76YZfLXHu9QMy1w)Nh764mWTlwv78KT7sQoGSBaop7zqgwTAy(0DKK9OLr72uKxShi0Fa8((aLOwykLjtJwsopFiYeE6FcDOEdQRqe0TupJhtLSvuwFBHRliEMfrm7)CszC6scLB9qWupi7vR8Oa87WZH9svYWHcdgcvEpUp7rwjoybafJogfW3Gy8SKmE6OnwElmaRvqg6aF6Q(EWpioU4W8DtDqyennSrBwjA4kkVJyd6G9hiGrWutWeFXjibzzWxrAyC5IBci2AJqSdLPCp6TpNEZeisopgd3wWGnaTSDQhQBIVaygn5dtP6Tfk7N5HdU(6PtcNF38PZUAW14TBk4lxn5YPFjeRHx4DtW)qpwoLRMmEQAcguTRp6pPZ3CSei6CQegIiGwGeVfi9Abg2WIwVKCQB)wTqUbHyONE78Ra(6WBhmz01HtVD0KrxIa)gSt0NEZWbZdNF1nJWhHDfwELC)kQAieFiWNIDAcsC(0vbac(lmWKilLgK6YmXlXcUzOAJdxEvWGHxpkC6eQ8UmUGZky(SrdUzKQHWhF1m4r3nHJp84PEIRqL89n0IxOsb0jFgnVOu0BAgCWJzFT6eQl3aUMSeaYIiwN)HPd5vu12gDal9IzaBm6kmlp48Xu0eOJhab6M0)Aq)Ro9VAIEEvvqdeuaPiCp4WsvRCOikdc28OY(l8fSi2UoGSJRnMZhttQHiDPyWFVJVHLnkuJ6EnD8e9kPOJNpsVod6YPUOaldJGKXx(er9m7wbYov1clRP81Uy7xfJY3vJh59E4c1lOXfDFbnodeahdQyoOMN)lBfh2QWchCnN(x6(83Vv7gQ20)ETAdifQ)osin1(JGzX63RvflJnEdCzB4OjmolHoEyhl1O8avAO0GiVeUN0UhHHY3ulktEQ3bQYI7kvQZVvuk3VRUQ32(z2tq6fkkGH50B4amdXnxx9C6MgWn2TaC7qvWhaRgam66XOAA5TmSww)DQu7YxxgbcktC0lG2uF8wVeTCtF8ljBzbwKUiaYcv(kskoEUREznX8vjkhV(fruVgRqyr7(NSu8MmRvEl7I1yLewgFIw3qweGLffzyl2lqMEFLYCpCagNQUeGIlcufFHc4oBJAx7Exqi5SLTCoFLdKNTn7gQCT9qoIKSbT8mr2IBRslR4oNJZ9pBSGUIgyzCL3ZAW1iKNt1XDQEVHV4XBPo7ZGE)XfQU8k8fVgS9)RWzAuwaE5GwihdnKIqeLottUGPWuEdUOqcLajT6A1f1Q5whLwPAIarxjW37HcX9KPlQ9h87ZhUtu6(gvknMVsuYJX28ncM34(8wD4(KsKkw2zdU6YoCg0joWe894XjMf1vSdrmddF9(px8Ej2Xq3uZ1NFnl1QlZQV)())d]]
    },
    char = {
        initialized = 0, -- used for first time load
    },
}


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {}
features.update_details_visibility = function(event)
    if event == "PLAYER_ENTERING_WORLD" then
        primaryWindow:HideWindow()
        mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
        features.update_details_visibility("PLAYER_UPDATE_RESTING")
    elseif event == "PLAYER_UPDATE_RESTING" then
        if IsResting() then
            primaryWindow:HideWindow()
            mod:RegisterEvent("PLAYER_REGEN_DISABLED", features.update_details_visibility)
            mod:RegisterEvent("PLAYER_REGEN_ENABLED", features.update_details_visibility)
        else
            primaryWindow:ShowWindow()
            mod:UnregisterEvent("PLAYER_REGEN_DISABLED")
            mod:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        primaryWindow:ShowWindow()
    elseif event == "PLAYER_REGEN_ENABLED" then
        primaryWindow:HideWindow()
    end
end
features.toggle_combat_handling = function(_, b)
    if b == nil then -- toggle
        profile.handle_combat = not profile.handle_combat
    else -- explicit
        profile.handle_combat = b
    end

    if profile.handle_combat then
        mod:RegisterEvent("PLAYER_UPDATE_RESTING", features.update_details_visibility)
        features.update_details_visibility("PLAYER_UPDATE_RESTING")
    else
        mod:UnregisterEvent("PLAYER_UPDATE_RESTING")
        primaryWindow:ShowWindow()
    end
end

--[[    GUI Options Menu
    Only edit the tables under args. Leave "enable" and "disabledWarning" alone.
    The name of each option is what you type to enable/disable it, so make them keyboard friendly. Ex. "exampleoption" instead of "example_option"
]]
local options = {
    name = name .. " Options",
    type = "group",
    args = {
        enable = {
            order = 0,
            name = "Enable " .. name,
            desc = "Check to enable this module.",
			width = "full",
            type = "toggle",
            set = function(_, value)
                profile.enabled = value
                if value then
                    mod:Enable()
                else
                    mod:Disable()
                end
            end,
            get = function(info)
                return profile.enabled
            end,
        },
        disabledWarning = {
            order = 1,
            name = "Disabled! None of the options will function until you enable it again.",
            type = "description",
            width = "full",
        },
        generic_header = {
            order = 2,
            name = "Profile Settings",
            type = "header",
            width = "half",
        },
        handle_combat = {
            name = "Hide Details When Resting (but not in combat)",
            desc = "Details controls its own visibility, but when you're resting and not in combat, we can hide it as a bonus.",
            width = "full",
            type = "toggle",
            set = features.toggle_combat_handling,
            get = function() return profile.handle_combat end,
            order = 7,
        },
        profile_import_string = {
            name = "Profile Import String",
            desc = "Paste this string into Details for default Hiui profile. /details options -> Profiles -> Import Profile",
            width = "full",
            type = "input",
            multiline = 5,
            set = function(info) info.option.get() end,
            get = function(_) return profile.profile_import_string end,
        },
        skin_import_string = {
            name = "Skin Import String",
            desc = "You only need to import this string into details if the skin isn't loaded with the profile or if you changed the colors/textures yourself. Paste this string into Details for default Hiui profile. /details options -> Skins -> Import Custom Skin, and then choose it in the 'select a skin' dropdown menu.",
            width = "full",
            type = "input",
            multiline = 5,
            set = function(info) info.option.get() end,
            get = function(_) return profile.skin_import_string end,
        },
    },
}

--[[    Option Page Show
    Removes the disabled state of each option. Also hides the disabled warning. Do not modify.
--]]
local function enableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if v.disabled then v.disabled = false end
    end
    optionsTable.args.disabledWarning.hidden = true
end

--[[    Option Page Hide
    Grays out the options when you disable the addon. Also hides the disabled warning. Do not modify.
--]]
local function disableArgs(optionsTable)
    for k, v in pairs(optionsTable.args) do
        if k ~= "enable" and k ~= "disabledWarning" then
            v.disabled = true
        end
    end
    optionsTable.args.disabledWarning.hidden = false
end

function mod:OnInitialize()
    --[[ data initialization. do not modify. --]]
    self.db = Hiui.db:RegisterNamespace(name, defaults)
    global = self.db.global
    profile = self.db.profile
    char = self.db.char

    --[[ option page initialization. do not modify. --]]
    LibStub("AceConfig-3.0"):RegisterOptionsTable(name, options);
    local parentOptions = tostring(Hiui.optionsName)
    Hiui.optionFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(name, options.name, parentOptions)

    --[[ Gray out args, maybe. --]]
    if not profile.enabled then disableArgs(options) end

    --[[ Module specific on-load routines go here. --]]
    Details = _G["Details"]
    primaryWindow = Details:GetWindow(1)
end

function mod:OnEnable()
    --[[ For combat-unsafe mods. --]]
    if InCombatLockdown() then
        return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
    end
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")

    enableArgs(options) -- do not remove.

    --[[ First time enablement, run if we've updated this module. --]]
	if char.initialized < self.version then
		Details:ApplyProfile("Hiui")
		char.initialized = self.version
	end

    --[[ Module specific on-run routines go here. --]]
    if profile.handle_combat then
        self:RegisterEvent("PLAYER_ENTERING_WORLD", features.update_details_visibility)
        self:RegisterEvent("PLAYER_UPDATE_RESTING", features.update_details_visibility)
    else -- still have to do this to fix details bug.
        Details:HideWindow()
        Details:ShowWindow()
    end
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("PLAYER_UPDATE_RESTING")
end
