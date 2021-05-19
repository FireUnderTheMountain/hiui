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
        profile_import_string = [[nZxAZTnYzc)BzR9dXUQiT4(yt9(bslsBflrPiqnoZwUeeibejkbcWfauYA2m63(7Zr3nUiPuMnz2u1mweK9Xt)CF14o97MFxW2YIhsZsWpwTU45WOYK8OWYISKW0Lf53T4UGLrBR3vMewMeLHJBn(3XW43MKLTmQQgFytA1Y4O6i8Zr7kP)MKNuU6f8tXrBIwLaFQ(UGsyxEikgw)Cy1MPFxa8Hzg3nt7ud833Mf9sszyCsDuAwv4ZP5XfptW3YiaqXju9imLGjzpD753fSiQmSo5hiiExqWJVKLMNGRt(UnjLPWCcREPQozdnZDvW5apM5PBIQtlYRqWRmzBrzDiEWcHP)yfESlt2u8eFQ3e(qzXMW8Onj8zfM9UnHWpxgLLfUSyZIO6W60ni4Pbh3KO61H1ffz1PBHtqC967MzARP2P6IWNxxCxaGCZIQQcbu5YkyDkkJRqKIJbJAqCITUVTPUHTahz6cFYe)e9Dw8yGd8mht1KObrd)qd2aGgXOfJKgHj9SL8zAG6QLTbko0yBd39b4(JTbC9eGR((hO1HG09CQSpcWoeJ5CSrRgmEcOf3vnC5GDoYO9uJ2X0WRzdCp8u8vtrra9o8WD0oegCWyTDDpcL5u5ODeOXw8F7bXqZZINhU2E6hHXBWsBDKb3BLnCSpcgFWGBOModr2dgT7XW1dgT3Xw7bSHo(hKYmySUAhdq6p8wJ(WAg6t911momsVR0MR(bH8E4eDnZdtC6TOghucUh7HUM1rq09wvZJXKoGVZ8ycadoB2hHO0t)KJ(bpD9zJSDocZFFQwdZ)G1DWqToICspwOALr)WQiWa32cYgOWALWaFmybUQoQExfyETbML4n5XtSUEGsaWK5mh8FCVl4BfLzXbW0tE9(GLfLK94hkYRxwKvugwMUADTyr1LK4wOwDC4OzCWImn0z6UkamCt0pcRJkxLuxHZnaDtjSk9xiFy(gp2Vq)PU7K2kNru(Y1iyKKbUa8ucoQTW3UyrzYtPKxbTgwsmyTM8Dapa0(mt3qHKqppcPJvVdKVURt)Ze7H1MID51OhglIw(4Qs4P4ggzFhjX23rs)WpjWZ4ISBXMK8DHpdUESnABsjs9KWg4esDMWlefcVdKXsZ6naf49YMOCYVJEiSOfPzP1PjviLLwUhIwcORPLP)YR3)x2ffxcE8969Zbe)cW1faD0E)eST9rcIrQCz7m2rVxVFCu5y63E9EtfrQ4HhQsQ7TIcUPQ1rORHaMerivHlw1SQNNxNuIG73dUEYfxm(QR(63dqhwxuu84jxdEJEIUcweuvlyHI(r6gepUjPEDrmr3fqs1YYKKCsCHHgBnxKTfGOtaF7ijC5y3wKMth166InTaVgp80VBQTTNMLTHPNHMNHPL1DpCc4QdSEt9mnatFggwEEaX3ud)fsMBQRJRLUPLURRPTJUVj(lK09uBnWFaDxlBFndttxFE1QfYhniDceqrLBiUudDuTwWf4dAUKxkbZB)W4wdRUZrPfLg1ayi(RP4Vwsp6rfovHDfVac8ZOscPVZPvH1LrvRrE5TpTnmQkeLm2IpJuSnrLpYYAcAfrxe(WJUpdIPGB5WA8usgUXwaOdpT8XWuW3)WSe87rbfmYdA8KOfmkoaJQJgtsAoOmmFzsvij6TmlfwyWj(ITjuisQibYsGOrYtEE5A4XKCkMNamWGW6x2MqQvWOKObMVBBywXQIDKYGMTioTkAbODgdSznO)lJ0boMopvRbmw(sqZAo8)u0zKk1fViICRojAdfdwxKdGXbuUCLRQltQxUMJQbL4rL8lA(9Sc44TlNOaHl2bmXCCsBGqIkFjSe2c0KJA8mkKPy0aBomv72UTmPssENb(S2(xtwbi06kAhbOeMAXwkSS9f3x9EO5r)qsZnP4UIbmked3Mu0QHt79kVa((fILDbRbje1qGYJmF9EvTHQijYQaHWGjrfxuw8Oqv2Db)pXBR(1xVh(xyc7kbQrDi8aQjjbfuGWHrKvSAVFh6MzAQCIc98Hc9EbZUA2e5xXsfEWb5L61PldJbOnbqt9N7H1GxfTzlYBqReix8qjgURmVaSDfa0bEhmm)GlU6BSfS4YITVHEFHuKGiVanEY21Di5pk8yddsV(UTaMfLdbK2trzSxgkMcjmv3rOK3xasdfANdYlk3WjR4L7MEITRPRHMVRVlOWvZ0auncABd(XDtDS8b3y19ST9H)dCYh(fu1eOOvZ0XZ1XgudBRPzr)caSiGQraAfCI5nafQ)bP04z4md)AZOK28BCLcLyrTh1RbEPvRdB4hjnlS9djtb7lWjizTknMuFGwvwfwcGoOF2Zx3qdmeaqocGG3LbRHXfcQuadNcDRTusiKKpklNqDaL9Nqk1qTSLoko(Q8QVlmz)9umRovFV9uQcnu8NW3bI4y(oItltwYA(LosvxMMVQQj5ii17zqTpQsLzsQEofvsH6vX8rvbmfTpsTXIciGaak3naopn)bIaHsN3GOekXqCERw(opz0q5JLGLIwUlAVCcxoAPQU1YccAjGVvtr(2VF75NiE(I0Q6t(sZeyyKyvOKOruOXibAmsFO8MbE6Te1PWgsq0y6pqNt3VdOs6kYbUfL5bmb73nitgKL8a)Hfj1pdE1iP9IJsJJPHC(P41FrVtFy1go9xVPpFkvpc8(uKd47tV58)R)Y8WWtNpFAJUKEQkpQFIgcw7JZsluoQaeXZAYJdOrlVc80LvK3s9KHwdo59XWGIbTCRNY3ydtezdTiojJusbwgbJh0Z3fq(Mw99rltJhxsPpe(9KYpJ(CE6LgOYZNBgnfG13N8xVE0SGZVAMMX3p7QRoB0zbF)tfzXrLLrF)txDXzJU5MrxC1NUn40ngY9lkB76ioqrXA2czZFHAi6Yj1mePdLVp0bX9G25rgfXmxvg9cBsxXpTCxvn6jIWokibO)RN(690Nm)v6pg)Qukzb6vhesqWhAio8cG5tLxqgE7SUlAlWqZPHXbCE2ZXs3Zc8H21ftKe7wn4ko4GUo4yTh4uny)q5Wn4kUNf4eUJfyCWYXqxZNva3OhLaesKoF3MfCyA8jypq34E6Peym1x3bd9bbk6VjqqFuGQK4OUIltHOCrZ2rGE4Oha6fNy)X7vC)DZLBbHpdo9wLOGWgffeFUGjsxrJ797d38wW8z)H0L172869FqSlFCV4N3JQhWTpzHmi2VdgqzhMJ2AaBXN4abM5QP5yBAA467ldmZ4G)I5b)fRwbYEeVYuCRTrF7xrmhEtvDi40j7gLCGGPLKTrWIchKG)wFXMbeDsiFfyWdcdMQobWeJ(vGl32SDRahVqF9FUNzDYbgwp3a7xWXDm6v5yojrcBsyAfubXxRS4ZvlIS3SjDzzbgrewviaseEbjcAlSPKqKFpkgBHdjQHdUmT6GUm1a3DuocZzXbNJYX3HYBFwWm)w6xiN7o0VyEWFrY3Wo6HEeLtAfK(a3sBEAolHcFeCLEhzZtJYd5BoqAyMTh24MHnU)6z9E3y7dSIdgOZ7DfDFZvKgM37DJ9FVBSU27EKVB6IUX7EKMV7r(Ujo62VZrwlRa7LyHqJYaNztxIAYYa)haV6XLbf)oQxPTigVPlSnQgWs0M0DyMI)RUBGf4IAiJNclBsB5CPhHCik05SMpZbuKAGlMbrpLq5jdD6g2YGZMmF05xeegmF08Bdgp6MWRV42pF(SWpbUy9vP31hEyxF21bQizXf(4JCoN3O5sV93e9Jawz75XvCO(ISNmxMzj8i)xVSig0Azdr16Rz6QdbVcFe1DiSepLm1aHNAaEsdolYF7pFPizN4dJGOs4C0HpfW4kXtF6nD3(O4GGjF(YjZM))Qt3StS(79OO)p(Jct1HZrA1xsJJtYLz6732zsgQbb9t9aNkTDD8maxlnXAIrjZ9ihAX504365Swet47G0Th5mtLCgghpNXdW8ekC1o1MIeq0njhNy4kGjo1gstWd3fl1UOHjlOjBsCMtO51vbwrEwcigZj0LCOrbsOAaWnbkJJ5SeUm)h1rzHCvV6TwVGzGqLwAYzJwEnD(NUAwW3pF2pfc7vAw4Caut3CSauRBvWfkRvTR4Ij(CsEYgXtn6abC5JdYexN0HKMZ5jbHzeuddRYJ2Yf4zqwv4ycEoDlPON9JsMOLwuduJFR4S65ywdXOjhRC23CT9mSrpy8TapH9DXeP5sjm7et)tDD8n8CHONWczgikBY4RMp)QlV58p)LEz)vLgnvYDAGpmf8aO8pChUiIu0U6Iqc1G8A4gtslJLA9jVxzS8pHiHOAGVf42tcf(M1MtQPSvk)tFdlGn1QRtGYy)ijc57irq0vAt3ty0SwLy3nSR27pM521CHY(i6sGSeo9ywuzMccXFb6Bkwx1f9SD3klEhWZGoSYqygKalrbePvxk9fgNubmeWrTtcdfHp0nDHTKD6(dDpduiofvPlJk(xS8itEQ0pQlJoPnoeyRYhM7yyYn1kEEpjLdMg4Mkf2eOC3(ZYTTBClumAbuQEePqdSKbNBdppDxpWwMpkuz50i3EQQaatTa0QTVoOnW132GS5zzXs9C1QewpyHgDP82xOcx1WiWsOJ5uVTzhOBnSLHezYH5kXllMePjjhvwpncw8woPvlTokACpmA7kQ8i4Ydmm1zjI8euLuci2qio7kozpuU)aTKa6yX(9ygPeLPCbjZYsJB3mIvlxNSHtGYGQlcXXVATQXl5MrSttiQkRjM3GnBLc)ETsrIbtSprNWXD3IMQsIFh3qMvybgfw)O0VxSlou0AOnT4jiG9ycy3cwoSouqSa4rNqcYcrc8SWrqwZqzJBO60dBpvjHapFi9bRXZfOrjzZc2L82Phg(EQVmbBs)qMCh0EWlTFOcGevDkzT1YAfcGAo2xiG4Scl8qw0kU8HWXePIRttYIR4ZnNhgrD8d(YTZMp5MEnQZW(0HQD(3gDZnNF1HgC7E0j4MR(8Ttuvx3Y3HTqk6vglUC8dN2LJ(8KHT5uZ0hmHRNm)Tg)PIEyIulC2n3E(znTgLeq4oEXZt0MJdHRRM91bDOKRz7XRAylUpdoBYO5F5RZiFagaG7FktMn5YF(quI2hIBN91zGptdGN9n2RV58jbZFxuIEu7BN95BU62RV(Ir)CddYX3SrGsa0r53321EMaRLiEK3MY0dopBcqD6YgljnoD6)VUy7VGLG59TFDWNJUy0zNp7qKPU7rWxgD5OzVjdA3ZdCAcoIizlGPUxZFG684U)a)uR2)q2NdGUbLhVnfUfI97fqDnLU0KQkmd5T1uqzSDGMItDCLTmJSB6S2NsItDLTwJJKoyzoe3irmwY(VXDG6al9E9OJpP5F0ntMnk8NNCXfkrc9(Ts8b5MTK7Re06RJqxrXeJqZQV(GU8y(hs431v1fKsaZSVgmZEGJ9EK2nuewXQmqkFGdPTvgRAVpz35zTp26tvTXNTIVZCFYP2sQRTed46FiHshlvRb2zSkpYbg3ztUD(nJUyFeYbQibgaDD32vn5unzVgQ3WA85BMmzMS(h6E6WKmSnH)ZXWOv9p8na)F1Ca3DTS0SDfnZwR4CPMxICJNVzf7PlLcbN0wbUUlBPhBzR3abuSDn4XemL1f1GOwo22nfBPOWMZoXlkHGSJIODcmNxXryj7GeUNMsItjNNwuwefJxHLULbL8PIcyw(XRlQ4wujOmkoDhMohStMO9LsHa3syptUQuexOYEg48jecrDZZYGK60vzIEcfpWyJxEaFJSWBqIW3ilpn2lMhIaFCBAipKic0vr(kWwP7HYOvKJL97(l2FAYbnfsJGdSZ2QO8MyPjtiYGUJfb94OsWVx0X22lYwGQUKQun(19VgoWF2SOiRIdPJ9Uh8FdZwC(dPuUJFGjiCnSiDP)37qSBCsTiWh665ao3X1wFze4RmTxfHyiM1vTBMTUnef(lOJ5nCErlxsTgy7RM0bTemWv8ffveYLCJmK64WFZD7v3wE2r8fDB0sP(h11jq2i4nD3Wb7omT3SAJ7RNVg)U65Rt1vnUSQVLLTTSL7(7(lkgxz7FzRPqbdRPwqce3FA9lhOtWe9Ly9AGPynMtuuAde8wc0zGH5jyMuGrO8qtx0biLwT(Ni9gI(pJJvzQTLMLPUVRJRTpe8QUipSswlMhuihPuN1oQp2jarrh4MG4VZEMONSjlt2sSVDK0QgnnSauKMMJ9phDQwLvSi6mUZIe3oTYKLrB7vvmoZTInKtvf8fzPpayoU7JyjVSKNO85YbBsuxr4FIq9iLVuZXIPQzZg2cf1b(yEHWCEqHvsX7Udt(c5lzaBiyjeXhiSgFxWR)5to517Hr869pVob(361jVEphq6R3ZddypsRH)bNiTc)srEsVv4ytgh(Fe)Xu4beqGHNMLrBlTEGfGA5cX)EDrhGsqa)3aabgAkeEpWzbl52D1VE)AG1vTUGIO1VEpQAU1MGFXYeE9zOikRQOZaQBb)8D3a2Rk5Hi(1)moBKHgwRhedKiZVEpeJlcWusMrau8RNH)kScc)zF9(pi4PE9EtBTp(6FwCOoDp3LXxV))hnQ)eVVmsaxzQDvbqaqVTtnYFebgjkQca(8AebWPKJXMsXu4jGNcGMvfiTb11WdGaAq0gMwsDneopI1Gtxs0tWd0oia)6YDjTG)dOgGod4qfhcsGVf2BreCiAULODWpMTw(EEWWOgtXIQuijodS3nWriR4zgnHM6iwxCQnBbgmWH3KMoDN2oCWInemZMX7fRhRZrqUC)N3K8acxJK)00D5Kz1Qp8rX6aoHG8FOxiif7xqbKyIIuMa2IroAGo)FaAca)N4n85IYhBFeahuE9EyvS6Wn1Z7MtB4NGX)No84ytg8avmEGDCb1sW4Hn)okRLHO2OkXpskuvF9hoeJYEAK((mjnBiw6eGNFzrElzkPQfI3rkvGPRejdkGSbaEaKZBdb77cytGanqbmSgjjB2rcoKOcT1sY9ZrL5KWbQDaxV82BOEBsHWsNygKGrXogfRR9NinFKZYSogPcW2Qjbvtv7v3kvpnMbNkahXTWPoexw67e5B)VNLvSwYzsD3oSr)gwjAEvmPtmDkhV4v9U6LCkqdzp8N8JTHLrPXWMTeTaNqHZpZWsJ6UjdlDpXFfpRrT5KHPNP4zh(zFFXZUIX7k(Ep27t2Nl0B71P1c7PydRbUC(yQijYCEId5IzgZv0lF7Y(FLihYpJgFUliy0ptxREX9qapMKAq82j0Y6FNVV5IU15RfxoFHpMJ3)V2Y139ozCPN6zaXAABy76yR57BJTfNLFV0iFaGypx3oQaE96vtJMoTtxsEvRHQQyyHxorNl9IMSKCwTCPrakQtCNVUZYO1DrChSPceWHcfOvxl2ztEhJFFBtByBQNPVogFUNTLUMj3rbMuTR801nD18Gq7bkcGbf(4EieXbzyKiiz5sr3)WiKuPkdDWeBQMprvyKB4zzBRjoxazy0o0AcgMp5f)(QV(3sI2ccgJbXfnxz)SjWjWkmj)P0YIC0jwq53uWKiOF7J7D1iGi8YOvqaItrhDskXXlB(n6w(bSNuoQccaX)Yv4vAfmK)i6KY1RFblvy2h5T2012u1pCIa7gapNbbzMFqaAe1aaVegS7HhkWR5LSR5iqzVhV60vGDSJC8gvUmcIQ6sGkCjfz9lYoSdxuN9TOGf(pEq0FWo0H(Pjv1H4ad2MwMwl7fpCjD3ZsEr0trh)iFZ6xkGpSo8NkYaaUq22E4k6TNveIvCtYXxYpHDsp2ORxxKwbCmAgYw8JqN(oM8cpTSOQErbAI8dxMwwIgUoh55zcRUPTNLJQP)ikRVUhtD)sXZzKf3XzKVCF4Yi0QYC6gk3mFttvRasZ3YYHy5dUi9jE6Gziy2G1MScmyjjpLdFXO4EdKetC9m4EMjyCu5JvBXsscZCEzA(JnBPLLPVQtbP55457ZN3VcSczOhNbf7Y6pvhBSDmuToiP0X3XNZuiaUKFyk)KVmQS(f0TQZI6GW8n9u9uiTegAUIt8NZIsr74Zlq3Y(G8X)Dd5KnmzXiDNMJSNUHy)lY)dux2cK7(GULJLUfpvx1u18eyRVLS4z0dIsC(8j)ZjB6VgGumeYpTgsUpWQIlGmjwWTGAXnPlpaD2rZH5t8vBVVdN32GXzffXqaoJPO36tUC0eQYKCyaC44PTFwSrft6ZzzO0IQd81da2wZqcJgTyOa6vdm(69FjQUKciPhqAOlEZJy2mvD(IsaegWlXscmVgVfjmpYFnk7xIs)XaKmAfIxkl1sPRRZl15RWWOrFFbnZji1Ak55DpWrx333KrA2Qfb7EajxwCk2X748VmjgndGlzFaXaFtGqVghKAV08oOc)aYixF19gnmBEyQVX5ckXanZiLwGtNifS7dc2My3KqRJxRJHN9WJX4O4v7H3X2ZZIMVIRZWZXssrHqOj)6)Akgl9hUgcgcK3e7TRLntsn1ucQ6Gq0rfu17lOAkz(8TSCfMXRlYteAQxc2hAmtsWlHYnnAFEDhEENSbC1yZE4dnPodbVtZTwa9HlW5q4xaZu0EupARrc5MwT0X4WW(NwtzErPJ7MD7rdlY54YN(gUpDlXsCtr9YsWphuk6Na6Fb4tZzfzdu2Q7Q74XmGMnA7085sDg8n0N9QTe9R3eD89CfhHg2pDnxgl8PICkttWr4SimW8VbHfTLI5P36y5dCp85WR95W(385qYfAA6YfVe0n8qYcqmajLO4WgfvWqJ0fzj5(88a11Sn5uSBnPD6aMKPe2oZsVTNXbxMKLKCyxxEUOmoKQb5mR26)8yxhVbC7Iv1opzZ2KQbODdW5zpdYWQvdZNUJeThTmA76I8IDaI(tG33duIAHPuMmnAj588Haw4P)f0H61OUcrq3s9mEmwYwHz9TfUUGWzweXS)tjLXPljqU1xcM6bzVALhfGFhEoSxQsgouyWqOY7XDzpYkXblaOy0(Wa(geJNLKXthTXYhHryTcYqh4tFOVh8JIJlgMVBQt(IOPHnAZdIgUIY7i2GoyBdcqem1emXxCcsqwgQyCqKVIBmlwJri2HYuUH92LtVfdejNhJkBdyWgwTSTQVuh7hvvlpF(SPxfo)25xDZ5JUWGkg3KzF6kQiSHYbnE0fxC1m1WWB5uW3oF2zx9TqSWUH3od)d917DD157gxceDovcdreqlqK3ceFTadByrRxOo1TFdyipGqO1xD98Zb(6WRhnBYfHxD9Kztodx8lXMt)QlhpAE48ZVCc(vy)CLxjpVI6fdXhc8Py3MGiNVCEaaG)mVysGLsdsDzM4fEb3muTHHZopy04lMeE1mQK9mSGZky(ntgD5ev3Jp98BGV62zC8H7p1tCfQKVBIw8cvkGo5ZO5DVIEtpJdEm7RvNqD5gW1KLaRSiI15F6QX8oQABJoll9sCa785kmlp48Xu0eOJeGaDt6FnO)vN(xnXfGvvqdCPaur4oWHLQwjhqugeStsL9x4ly1ZDDazhxBmNpMMoQwHE6jo(gw2OqnQ71KBGuhvdrVNwHg0LtvwgldJaLXxQerzo7wbYov1IEN2iEfn2(12O8964EEhjUq9YCCr3xMJ3acGtbvmdQ55)02XXTkSWGBS0)upN)(TBxsLS(3RDBePq93rePP2)xWSy971UILXgVgUSnC0egNhthpS)nAuEGknuAquVFaoKDpccLVvxuM8uVVuLf3vQuNFdQuUBBDvVJ9ZSNG0lFuacZP3(aygIBUCh509lGFF7iwUTOk4bRvZcm5IPOAA5fgSww)DQu7Y3wgbcmtC0lG2up8UXeTCDF4ljBzbwKUiyLfQ8vOuC8C)(UO1TuohVWarR4MqxaWIBbqYsXR7Qw5TSluJvsyz8bADdzrawwuKHDxVay69iL5EGagNQUCFIRlufF7c4(8H7uOUxJi5SLTCoF)dK02MtdvU2EahHswJwEMjB4NhslR4(iIZ9pBSGUQeyzCL9gp4AeYZP6)ivV3W3H4nuhmzqVR5cv3Lf(Ewd2()fGMgLfGxPOfYXqdPiebPJ0Klykm1f9SgfsOCrsRUq1Ein3vP0k1BylrxjWoYviU2mDbT)L7D)J8Mw3g2Ftm649HCA6LIH4jgxx)BKq8(XLIYBahUt10amkGFW3pCpt3XddaLz47J(V4zQWxtTS1DnW7(HbmypDNM70X7fdwp4nAvAmbkkrJ2YIDU9YCbXgi6Q0YPudCZOZpRJ0gjfbcwVLEdsauD7graZ2ZU)xlETq7OBzamA6o9AzZ67U7))]]
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
            desc = "Paste this string into Details for default Hiui profile. /details options -> Profiles - Import Profile",
            width = "full",
            type = "input",
            multiline = 5,
            set = function(info) info.option.get() end,
            get = function(_) return profile.profile_import_string end,
        }
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
