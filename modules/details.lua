--[[    Header
    In this opening block, only the name of the addon and version needs to be changed.
    The version is used to perform automatic initialization, and should be updated everytime you need first-time init to run again.
--]]
local Hiui = LibStub("AceAddon-3.0"):GetAddon("hiUI")
local name, version = "Details Config", 0
local mod = Hiui:NewModule(name)
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
        profile_import_string = [[nZZAVnoYr(B5W9HmdqSp((XfCFqAS0moJTSJP8ozpmW0uK0seMIuHKYE8Ez9V9RE0DZh6HDwCzVaS7yjQURU6QR3v18o97MFxWMQYhYYtXpwVQ85WOQ0IOWQY80WS4YI7wCxqC0MMTvPHvPr544wH)Dmm(nP55Xr1n4xwNvhNe1eHFoABf930I0QLVGFkjAD0Yu4tn3fubRYdrja8laOnt)Ua4dZmUBM2Pg4Vx3al060Qqy5FiBjUIpalc8GTBGviTgXP)22S4hdtsBsJBYy0SkToTjeqQ4W4O4vP4ZkkdJYtRAO5STonmQiBDeoJWO44uABKKvhTa2URFPzvwCyY2ILPeebCjkppCtE0lPv1iLjCzv52nsyvhdKPCEP3uw1eIeMW8SIhR5hUU8jMQTo8HQY1HfW2IPvawSDDi8Zv4kexUErutytg8ZZ01ac3tPfW3RIIFmTcjaWzcGIjiyFOe(P4Y8YkM6H)Nb9VM0)AH)lG6aEKcyu2YvnWtCepO7e1ovxq35jt)1c)RjcaAHQxfLu(8DbZUA2e5JY(fbAsF9HO407cMwL9lVE)FzBusfWe869ZXtTkC)kzSAYAYPDpC(I8jbxC13UlybSftQk3meXCKyMJe1Ce4MLlT7kbsdrpKBrtnaJEolPzfmvBnfjOj9hi37DbNL2eLLx)69bPapEwZl3fuUbzfQdLyAdXFYhMnLHpVQ8UaK9SUjQioToSoD5A4KPouS8WUjopnc4mliod(riVbCEcBx8HfjW0QGt6WnrvWNWrSb4MwSOk9PmIxe3IbpxwLNizfYQXt)6ve4iUEKXga)uBlnltDFxhxBFdFhT7E4eBlGoww(46OQhPTR8iceTA53P5hcSEaGFc48rsP9Dbetwywt66W80Nyjcs6KxpKYBJ01cGnO(OYTTKjGgTnmohLqbQy5Mus(uXTtuSI0NJxbFnTG0leeVTQcz6t2GZV53mBpR)soXXVjBShio2tWFN5Eyg86O1BafhmKS3pd)I3fdpthzwDbFUX(zZDSB5YniUCb)bCWcSzr5S87(zTrf0e9Vy7gGhEz52ge2TNCG(Y8Sf8Pn(letiQiogwIc4)j7biMhU4fHTIgqBnP1VpRgSzmBvUIk1BIxX6bBklZxevHWs(74gvkffUyBtdG7KQsqjA1lHWMa26wTJNrrwFmnWocPB3SbSfiLGMbYibOQ1WMx2KgwwLTmRajtgTejXggp5Ib7fswPHYor)qk7G7S0hI2M3eUyjyIzZQiKUB3zLOfqXavJahLlQ3lReE2Kg1SIinnzBcfhXMGImbE01EJyucJXjGUfyZ3STgjQsvOMczttHcutbFLhYQUail4)4ExW3q9obW0tbnJXLGMsHUF(yUIy76kYPDQBhg19yRXvHGijlSjQAzkybgPhOlfS8cG6FJh7xO)00FsBKZaotxHOrAoCu8ukoQnWt7P9unm4qQPKunHBaHeUHIir6g3vhI2P(6Uod3tS3qRbf4Kmck3YQZBns5RSs5Rmt57OOZiq2UGug(mOPBt0gw7Ve3eAiitPeHzrzLanJlHpI0OXe6zO75c8wxGFrZ1t3a(Y8UF5ModRbLqxVoQiPMK77rxJwKLN1Kb8JadaHjhw9MaDoUIkIw1I4dm1ooQAm9BVEVP6SS8Hhap1garbtNqr9cHWckDPG65OgoeD)EW1tU4IXxD1x)Ea6dkA87KRbhmprxHlIdFqLbSTZwJKBWSYQYeI9qGjGevAAr4MYAb2yR5IC3agDci6DQnRgGg7MsqdlcEq306oOhDujM)uBBpnlBdtpdnpdtll26maVPEMggo2ggwEEapIjz3MenNcMYT0nT0DDnTD09nXFXgPTtT1mC00DTS91mmnD9zO1v8842c7GJDDUYtW16j4z96yXPRDCEcaJqOGcbUtxTMJb4L7MEITRPlSp99nSa)rCWnlSJd(XDtDS811mnqhu8DD9nWFbDXb2SAMoEUo2aPWwtZYd)fG)fTMPrmb1aQYlakw)d606zH3DQrjfpB16HMLqhoAwbYOlxf2AcJK)4Zqj1IfBpbT9xNLqAQXt2LHvaQdsuE(6gAWHHVJhIG2GKYkyCHG5sG5v4JwhlHcZvh9SqyZJcQkKI4Qd)8OKKRkQ)UqS57zyWs1FV7uQdnuoXSodmeecwcXitu(Ik8rcm0MvSSU1acE89Cun5gg7vt9ZzOPy0xmmoVAW1HU7PUKrbkqyaftdq0ZkEGoHq5YBqAcQ9xepy87CRrdL3xcEkcCx0fCc5(WvGzLCY0shWc6RsbfCtrVB((TNFI47xKv3CYxANaJJeVcfCkDengpHgJhqu8OGw5ykClYOnA7i7hOHK9BSqEWISGBqvNaLGTrckXcYtFG)WI0MNbvlYdFXwP1ic4fwe4Icd)fd29H1R5WcFtfVk)le09PihW3NEZ5)3)L5HHNoF(0wpoh4qTqbPGj(nyEpMIDJ2GfvrgYBhWBPIAWCdrl76eRHwln59XWGYbDmbRMD82AqD8oabesktsZjLwG7GG9a673fq2lQ)(O4SKXvKhxWVNw9z0oWPxAGEC)C7OjFJ((K)61JMfC(vZ0m((zxD1zJol47FQmpjQQk67F6QloB0n3m6IR(0TbNU2qUED9jKHzhAp)a1q0LtQDincxcEFuhIzcD9f5BeZCzfOCG8MvXEjiw0PrW)dkqO)RN(690Nm)v6pg)QuOzbL9byGFyi1gJjEp8RKRnkrhA4TCwGTmphlDplWKMRRHJJWkhyzeSxQd258aBCU(SXc8xalJEwGnrhlWoHLJHUUgRlUhx5fSWDX21lyNRyKNjK92WJhOXQfP5h3J48bb15VlOnFuqLKKN(cdtbFthU37kQ3Hm4aUb4QP5yBAA467lDdW4G)I5b)flHBt7zfF3YuwGJ1qy51PkQqRAP6dqYEp6Le8B7by9X0oeXZ(dzXnBx)69FqGsFet)gjHOtjYtMosI7(q(qcEeu1eg9aMUqAcVDu8kU1UyRsMzpCsl4esgUPwKrs5OblnPBIaidKNG)UijHklDS1MSLGbpWxuCTqwx0XcC(BY3cXLwJr0c2QYQe51KsZcUHtsRbFDayZAq68vkDlCAxBkdjhvONmxyoAS0afPvre4Skox2ZgjPs6YH0Ti0POLh0PiY1k2kEx1DWCwCW5OY)XUIrFwWs8wQni33o0VyEWFrkVWUYHU8uqhNsVC7OFoRGfkGp(uu(wYOgoxyDFRbsdZS7Wg3oSXdHN17DHTpae3zGoVxi6(MqKgM37DH9FVlmOh)9oY395IUX7EKMV7r(UpC0TFNJevq9ywXDbxIvaikh8wnlgvqLdEeaUTJGbf)oQBNDomEtFuBuE7J1MiT)Wmf)xt)ihqGAiJyAMl4QwafMf4Yxq0tPuAjqhMbOfC2K5Jo)IGWG5JMFBW4r3eE9f3(5ZNf(jWFOVkv8C4HD9zxhOsdhc4JpY5C(1Ml9uhcTpGvuEoecoLmxrk6NlZahUBMs6(Hqhnahxbh34N(xVSmbutzRzQ7Rz6QdXJcXSIkl05b8ZxkYwa(LrqefCI6XVfWE6k(2NEtpOpkniyYNVCYS5)ty3n7eRdVv0))(TcFQd7JS6VKLKKY2u(nSNySxgMaH9t9a3aTDD8maNbn11e5w5iKaX(0436(Srya9DC010ZyOk0Q2NTBKNW6mg1RpMtfRiAsmRCQCG1jzmIKm0prgNy4kqDo9fsJW7kpBPKN1W8b0MYao7i086RcRSGfXLoGaU)us6)j)xaLu18OYtbDcsuaEAiP7Rz3esGOHPcnW8s0u2eLhY5SU)sN)cMtcUyRJ51VR7SN)PRMf89ZN9tHa6KLhohaz26JfjBJOWYT1HPxAoYk48FGRmUGHH1frB6L9uk9xDtFQj(90I01IVj9SqLmLohhCYQGFvs3qRaDIMQTMlCQ1CT9mSrNx8TaN)9rpySCPmRbHg57Qz546OBAyztzye)jr2jhF185xD5nN)5VmOwgQmLPsFtl2HfMlp6L)p3JRUMF4gaOQFQMqxD50SlR0cHyf4z50iWd0owgAumy1y1z77HCudWKbsiC1EhMOdvkLvE1(g2nvHX0pGzS89I4)os4e9Lq19eMAfbff2wuI9hzHO0HRtRyfad4PujPccVFb6flwoKfdSY3HkFaFiq3tKfEMcBqu(vUI2DKmGJO6oWxCmoiVQHa9Ty3KRUd2tX5uwNfhv(VAztM3EGQ2h7SBXV2h7BRJZ8bYnhj1zYI50gQQEVk9621RUfkoOakxoIuMbw)GTOHNNURhy)Jvj40kfFQQSWtbYNNTVUNRURVTHMGqkASgCBjmLWsd67jFWC4ZpNTjLR8v1UHLAWr3UElOBmSJAEIZOF(PBtXEBZvGztOMQzUOaVa)wkW6NNqSKBEAtyuDRbG950ms9RY4gvipplPMd1VcSvgbi5tznVqYrHaWy2AmKBHbAopz)dMwTITGujW8Mhw)sDt6AI4XDhe2js4m3xLKjp6vr7g84lucUf7Pj5pD75K7dIEcQxVazlRapjJYnueVxk3Mek6lR2(RcyyFmfmkbugSLgG4jqEzQQXYAYB0jvTDQjnQqc13TcxAqXs66fSJ(DylXNtDWeyW6hYeWG2pEP7xQHLvvFEwfwsAusE5YqQRMqBLg7PzqAkRwUs0lzW2dZCYQS08KAUMeCQzevAl4l3oB(KB6N9NtnSf1ZYWwiyrLV7BJU5MZV6qdww6lAO3C1NVDIQmzw(oA(MU2YIEBXLxD3PD5Op3old54BN(ot46jZFRXFQRDRoKZU52ZptndfIWLU2ZZGQb8EWRRM9v1SuBdZUJ)ujPIRB8ztgn)lFDg5(Woi4(NcSibh5SO7242zFDg461oy0(g713C(KG5VRZIbN3bFz0LJM9M03(tAeObbDZ(9TGDruG9se0ZBF6myrpBcq86ZklpEC6AMyaf)lyDxEFRxpk6OlgD25Zo0bv)142zF(MRU96RVy0p3b5o6j2KztU8NFhSbn7r4FrzDD3wXe(rL5J2k5ou)l8N1lkZRzxyg0KAyRnXDPg(PUTxQSh(4E7a7qTAkeglnYn5IKOQKqs78cz79boBTzfy0bqXvLnXLvfy3ouUHcpCo7MJOHrh0ZqGvXLGdtY(gYUTNJ4wDknjJu5TOQmkjMBZ1o6CjRcuKiYpEDzn35xbvrjzKQBhryYTohwwWDF3ZK(8YKsv0(GTAWPlkfLmwpUFR7jA4fYYC0pKTzLSJDK1VZYUTxlT80yL8Q2HIDSg7ofFlDr4COf9hQIw27yUVdjKXk1HdAWd4sQzh27LB(DmaCQJRSLgKD7K1(09FQRS1hCKIwwM7r24uvJ9yRyGn3rtVL(G(OWN8YA0ntMnk8NNCXfkDD69KMnoIeMLuzLe9gQ(xxPntmcnRHQ67R6W)q61DL0mDdjIzo04K5a0XEpQXnucxcOSJ67DI(ONQcGSPR72TmsNQj7Ik9DvOlXijk55UpTW2YdABjHW1)qQCDSuDXvVXQIrc4HNn5253m6I9DEo0XbvpLjBjml9w2IpFZKjZgCAR35SMeKkEjSoMksuADn6iApjJnGkMyQa1DBQ2hYJwYT5TqKfKywVrgfQxhYRbhCYj6w9Ag)dQVeDZVQBm6KiCFv4TTsklOIf9QJ)AZCm6ypw332uxzwU1ISUY6ijHmZXSLp0DOtidhm2X395qg6tKUCG6TnWNclo0yn21pIHU0PgBl6kThRV)bADimDp7k7JGS7sXCo2Ovd20vaC3DSS7CKr71kXykCYOV3a7of)wTnYr7D4H7ODik4oJ1219iNmkNzCeKXo8F7HWy621TSz2E6hHXBhqBDKbpaYgo2hHIVZGBpnD2LyVZODpgTENr7DmyVdBOJ)bpz2zSUAhdrgo8oJ(WAggE6RRzCyIEFPnx9dI5dOj6AMh(WzaqnoOe8a2dSmfhMqpaQMhJjDh(oZJjaSZEZ(ihkd0p5OFWD3q2iBNJW8p8uRL5Fh4UZqToICYawO2KkvhVkDTODrsF(q(UQdkYK(UAQtMVf3bokoaQvx74JkFRYeEOowCfkaV1Fu0VZyJuTP(xF9E4F76iTC(yYFA7GXXYQEStdSltssE26mXf2AqKkuekW6TmVCr0zC3mkU1avPXCqcCHgeZdTh3PyX0VLN9aSf5oEKVKA5PprfyIZ4KlFnrOSjjYCe5koDjEWsXSEn7we1H(ycOXuSs3roQrt2IzlLcpnOuubN4vr4D8j41)8jN869nRYQF9ECmVEpmA4ZpVkTaFo8aozAVEpv6PxVVe(FQ(sVEF0R3Zzdeb7VuwKYqnrc29aeEeWcGd)p2FLFolpNwFcEqKvnsaX)Etj9Rs4kYl4)2R3JdnlkhZEgaYnBBE9(vPvPk4crjUcqCiKNolc(G40U7)O86YEdOPd(ZCJWAvl3ejV(NXzJSYaSEqmq6ShOqLlreMQsfIGIF9m8xbiicK(17)GieTxV30w7JV(NfBQt3Zfp517)VOr9N41LjciKPB8dFW09gU9hrKrsIQbKVObjaCILzQPmNSW3agnaBwwINny7aXdGq6Y8eyAPnnzflrQgF(dFHwbb63uTnTd(FGC(s7bCOInbfpEhQhiycyLYP2E0hZoGFqe9mPXuauvARf7boAFylKx(mtMWofd(op12LaJq9Wls710JwoCWIfmoczzW1IB9SEBbj4(pVj9beVgj)PPBlO82x)HpkGdeCpY)HAiXtSFbfqsOtKQ0)22SkwK7)aupugj2Cpxw9y3Tae4)R3dqXQh30GSgCAl)em()0HhhREMhOIXdI9qCAjy8W7AgkRLJK2OAXpsbDOE8hoeJYEU3AdzsAxqSsiapFCzrhzkPQfI3rkvG13apguizlc8aiN3fd23nSMqbAGcCyfEKSElj4qIk0slpUFoQQGeoqTdi8k6UG6DpkexmqXmibJYTmjwx7prA(Wa1gOjTJAV9RonRPMyOJjiq6Nffi7Fev8c96Yzs37sqP)VbirZRMpLetN8jaV211Vue392LM(JnHvrzjWIfJ2utP0jnZWsJ6lddlDpXFfFxJAqddtptX3D4V77l(URy8UIN7XzuJlJlAQFvwJWEk22QqyZpMXxIprDRc5oQiH72GInXdFKW7MNr7m3fem6NPIojUHS42K04H3B2og77vqivjPX6GQr1bvtwnCxjXsbfrfTeLnF8()1o5OCVtgD6AQNHUpwAwxhBnFFBQWT(dWT26H3do75w6rDAW(AwCZ2Cf1dg922NOB0FJBTZ4BrL(y4rjehQlc60m09G27y87Bz6UxM6z6RR7P54zBbrTWDcLjvQCpDDtxnphDK0BBiVD4D2X9RuyldtFkHCl3iApa09pmr9Q0XJ(tInd4NOUxGVvfYoPvSVa64OTOHdmN5ucN3xh88T0OnGGXyqCrZv2ITcAcaHjfpLvvwG(Zc65Mcw)avzFCVqJqIWlJwMfhof9PjTchVSFCPR3hWhsrFeeaI)vlXR8kyZ(r0FKRx9c2zc5FKxAisetvl6kkO)o4ZzvG(3dIqJOMf6LWGTp8qjEbQLnYlHk7D71KTemzDKT3OQ4OI0WlHtHlPQf8ISPFrG6SpGcgZ)4bj)bBrh6NMw3eIdmytwvwJS9Grq6UhqEr0trhFlFZQxkHpSk8NkZbeUu2jXie92dedGWEspoi)eEDDW(0)6YSAGJrZq21Xe503XKb80QY6MfLO1WpCzwvf6sW5ippFWQBA7z5O6dz6K1x3JpD)s5Z5KX1X5KBBF4Yi0QYC6gm3oFttv3jtZ3YYHy5dUi7jE6Gziy2G1M8smyjjpLdFL952vMetC9m4M4lyCu1J1BW(IaM58QSIhBxslltFvZltZZXZ3N3VFfyfYrNldk3MpCQo26A(MQUzMu6474Z5BhqxYLlLlXxgv18c6b1zr9iy(MEQ2CMaHHMRyh)58Om0o(8s0dSpi)6)UHCYgMSyKUt7w2t3qS(Lf)bQX)HJ7HOULJLUfpvx1u18euRVLU4z0dIkC(8o)ZPRhcdqk2YuNGHK7dmF4cetIfCdOwCDw8boND0Cy(eF1Y77WfliyCEzzcelZykqTHhxoAcvzsomapC802pl2OYjd5SmuAr1b(6Dq2oZqIJgDyOGZRwC817)sutff7XaK0qxK2vZ2PQZxjl4GbC1RIqZRXRQgZJ8xJY)LOSFSdrgTcXGYsbkDDDguNVeJygDZf0mNINwtjNShGo66((MmrZwbeSdMKCzjz41QbN)LPjOzaeKdredmnOuoSKAV08oOc)aYi3q19gTmBEA2mZgOed0mJN0cA6ePG9quW20tJzAn86Sn8S3DBmokz5E4DS98SO5R46m8CSKNOq0YKl8FnddB(dxdX9aYBI121YMpsn1ucQ6Gq0rfu1hkOAkz(8TSCfMXBklsfAQJb7dTMjj8Li5MgD3VU7UFNSgC1y9E4dnPUtdFBH0ba67cGZHiTaMPO9OE0wJeYnT6OJXHX9pTIsYIsh3nB3JgwKZXL39TCF6wcqCtztCf4Ndkf9tW5Fj4tZzL57OSv3v3XJzanB12P5Z5Nn4BOp71BOZVbt0X3ZvSfAz)01CzQWNklOKkbBHZIWyW)gew0gkMNbWXYh4E49Hx39H9V59HKl000LlEoOB4H0fGyaEuIIdRvNcgAKUilj3NNhOUMTjNHTmoTshWKm1)zZS076zCWLP5PPh21LNlRscP6FpZQR(pp21XBa3UyvTZtxVjTEhYUb48SNbzy1QL5t3rs2JIJ2SQSOClqO)e499okrTWxgtKPrljNNpezcp9VGouVc1visaQupJhtLSvuwFBHRliEMhrm7)uAvswmHYDEiyQhK9AuEua(D45WEPkz4qHbdHkVh3M)iRehSaGIr7Jc4BqmEwsgpD0glVfgHDmFo6aF2dd9GFuss5UDmjDvfJOPH9V3dnYAAdUJJz3g7pzaJGPMI54IZfcYYq9Zce5R4w6Jnole7qvg3FWTVDRKpe7ngWMnaWC57liuDhqBv3wJZNn9QW53o)QBoF0fgulTmz2NUIk(FOCqJhDXfxntnm8kAe8TZND2vFleBOGWBNH)HE8EHl9l0Ryo(nTKiiOfi9BbsYwGroSOZ7ChSK6f0R7ijAd79RUE(5aFD41JMn5IWRUEYSjNHq(s8s1C1LJhnpC(5xobFewR9IA5Mv0Kcq8HaFk2aBi0(Y5ba29ZmWKykLgKMQCXlMlUhl7spp78GrJVys4vZO2fHXfCwbZVzYOlNOU1ltp)g4r3oJJpC)zzIFnailSYIxOmn1lFgTV0v0BVelGhZ(AnPuNlaCn5PaKfrSo)txnMxrvRH1dSuHzWEwUgZYdoFmfnb6i1pq3K(xd6F1P)vtCbBuf0abfqkc3coSu3jhkIYGGnUU8kkaXG7O76aYoU2yoFmn7EfnC8nSSrHAu3RPJNOvTfxrJ9C5maD5uBzHLHrqY4ldN4vry)(WT37do62piEDl29vWO8D04E6EJfQxmJl6)Iz8gqaCkOIzN39A)tBfh3Pgc7Cjk)N6(83Vv7s6Tl3VxR2isH6VJestT))GzX63RvfVdG4D9NTHJMW4Se64HTazRYduPHsdI86(Fq7E89boq(ghuz0RrEFcKL3vQwNF7(vTDtt9Gn(ZSVGyt5J4yb9sobZrC7TlRGktn3DQcWTbvcVdSAbWKlMIkQL3I5g5nRGU7aY3rpbcAts0lG(up8(3ffVAi(LMhxIvKlcGSqPVIOIJNVtbl68UrOaV)rrl5RcJaHfx8O0yX7fTozUSpwJ1sio5aV7uLLbiUSmhVZscKzWxPC3dhHjzQRLS4kjwZxNjUg)uBWn4QkkNT8ERXx4j5zB7UHQn7aKJijRqBpZKDn7dzv1CZ4Yz)NnxqVniWA2kFXpaEtGCDQEpq9IZLFXgSMAayd6TrxO6QYXx9h6j0dkdre4ixMjmLL06Nv32oa1xOUkPTxzsrdiq(IqnQi9g6R3c)VCVqXKVCh6I77sVWlA6VaYar5b4UDm5agfpm99fVfXHPTn)gj8VFAPOkpWM7unnnFK(GVMaFMUhzgajZW3h9pXZurVMAzR7AG3VmdyWE6oT3BS3lfSzN3LQzjeQOy87kPje3tgkn2tEvQdtjKFZOZpRNSejJaInVLwbs8sDDQreZ2ZE4JfVcMD0Tm8TT1Dg0hWn3D3)l]]
    },
    char = {
        initialized = 0, -- used for first time load
    },
}


--[[    "Features" local variable
    Define all your custom functions that are used by the UI in here. This makes them available to run at once during initialization.
    Remember to set/change db values during these functions.
--]]
local features = {
    updates_details_visibility = function(event)
        if event == "PLAYER_ENTERING_WORLD" then
            primaryWindow:HideWindow()
            if not IsResting() then primaryWindow:ShowWindow() end
            mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
        elseif event == "PLAYER_UPDATE_RESTING" then
            if IsResting() then
                primaryWindow:HideWindow()
            else
                primaryWindow:ShowWindow()
            end
        end
    end,
}

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
	if char.initialized < mod.version then
		-- for _, feature in pairs(features) do
		-- 	feature()
		-- end
		char.initialized = mod.version
	end

    --[[ Module specific on-run routines go here. --]]
    self:RegisterEvent("PLAYER_ENTERING_WORLD", features.toggle_details_because_resting)
    self:RegisterEvent("PLAYER_UPDATE_RESTING", features.toggle_details_because_resting)
end

function mod:OnDisable()
    disableArgs(options) -- do not remove.

    --[[ Module specific on-disable routines go here. --]]
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("PLAYER_UPDATE_RESTING")
end
