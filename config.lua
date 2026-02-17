Config = {}

-- command: /sling 1 or /sling 2
Config.Command = 'sling'

-- ox_inventory is required
Config.UseOxInventory = true

-- Restrict who can USE the command (everyone can SEE the slung weapon)
Config.RestrictToJobs = true
Config.AllowedJobs = {
    'police',
    'offpolice', -- remove if you don't want off-duty
}

-- If true, any ox_inventory weapon can be slung (recommended for lots of addon weapons)
Config.AllowAllOxWeapons = true

-- If you set AllowAllOxWeapons=false, put weapon hashes here (numbers) or backtick-hashes.
Config.AllowedWeapons = {
    -- `WEAPON_CARBINERIFLE`,
}

-- Attach offsets per sling slot
Config.Positions = {
    [1] = { bone = 24816, x = 0.0,  y = 0.27, z = -0.02, rx = 0.0,   ry = 320.0, rz = 175.0 }, -- front
    [2] = { bone = 24816, x = 0.05, y = -0.18, z = -0.02, rx = 0.0,  ry = 165.0, rz = 0.0 },   -- back
}

-- Component normalization:
-- ox_inventory usually stores applied components in weapon metadata (hashes).
-- If your server stores component *item names* instead, you can map them here.
-- Example:
-- Config.ComponentItemToHashes = {
--   ['at_flashlight'] = { `COMPONENT_AT_AR_FLSH`, `COMPONENT_AT_PI_FLSH` },
-- }
-- If ox_inventory stores components as item names (common), map them here.
-- These lists can be broad; incompatible components will simply fail to apply.
Config.ComponentItemToHashes = {
    ['at_flashlight'] = {
        `COMPONENT_AT_AR_FLSH`, `COMPONENT_AT_AR_FLSH_REH`, `COMPONENT_AT_PI_FLSH`, `COMPONENT_AT_PI_FLSH_02`,
        `COMPONENT_AT_PI_FLSH_03`, `COMPONENT_AT_AR_BARPFLSH`, `COMPONENT_AT_PI_RUGER57FLSH`,
        `COMPONENT_FIVESEVEN_FLSH_01`, `COMPONENT_SWMP9_FLSH_01`, `COMPONENT_SR25_FLSH_04`,
        `COMPONENT_M4A1FM_FLSH_06`, `COMPONENT_MDR2_FLSH_06`, `COMPONENT_SIG_FLSH_02`,
        `COMPONENT_AT_MCX_FLSH`, `COMPONENT_AT_PI_FLSH_M17`, `COMPONENT_AT_PI_FLSH_FNX45`,
    },

    ['at_grip'] = {
        `COMPONENT_AT_AR_AFGRIP`, `COMPONENT_AT_AR_PLRAFGRIP`, `COMPONENT_AT_AR_LOKAFGRIP`, `COMPONENT_AT_AR_AFGRIP_02`,
        `w_at_ar_arc15_grip`, `w_at_ar_drh_grip`, `w_at_ar_grau_grip`, `w_at_ar_jrbak_grip`, `w_at_ar_m133_grip`,
        `w_at_ar_neva_grip`, `COMPONENT_MDR2_GRIP_03`,
    },

    ['at_pistol_sight'] = { `COMPONENT_FIVESEVEN_SCOPE_01`, `COMPONENT_SIG_SCOPE_02` },

    ['at_pistol_suppressor'] = {
        `COMPONENT_FIVESEVEN_SUPP_01`, `COMPONENT_AT_PI_SUPP`, `w_at_sb_hfsmg_supp`, `COMPONENT_SIG_SUPP_03`,
        `COMPONENT_AT_MP9_SUPP_02`, `COMPONENT_AT_MAC11_SUPP`, `COMPONENT_AT_PI_SUPP_FNX45`, `COMPONENT_AT_PI_SUPP_GHOSTGLOCK`,
    },

    ['at_rifle_suppressor'] = {
        `w_at_ar_arc15_supp`, `w_at_ar_drh_supp`, `w_at_ar_grau_supp`, `w_at_ar_jrbak_supp`, `w_at_ar_m133_supp`,
        `w_at_ar_neva_supp`, `COMPONENT_AKM_SUPP_03`, `COMPONENT_SR25_SUPP_01`, `COMPONENT_M4A1FM_BARREL_03`,
        `COMPONENT_MDR2_SUPP_03`, `COMPONENT_AT_MCX_SUPP`, `COMPONENT_AT_AK47_SUPP_02`, `COMPONENT_AT_AK74_SUPP_02`,
    },

    ['at_fn57_blkframe'] = { `COMPONENT_FIVESEVEN_BODY_01` },

    ['at_clip_extended_pistol'] = {
        `COMPONENT_APPISTOL_CLIP_02`, `COMPONENT_CERAMICPISTOL_CLIP_02`, `COMPONENT_COMBATPISTOL_CLIP_02`,
        `COMPONENT_HEAVYPISTOL_CLIP_02`, `COMPONENT_PISTOL_CLIP_02`, `COMPONENT_PISTOL_MK2_CLIP_02`,
        `COMPONENT_PISTOL50_CLIP_02`, `COMPONENT_SNSPISTOL_CLIP_02`, `COMPONENT_SNSPISTOL_MK2_CLIP_02`,
        `COMPONENT_VINTAGEPISTOL_CLIP_02`, `COMPONENT_GLOCK18C_CLIP_02`, `COMPONENT_GLOCK17_CLIP_02`,
        `COMPONENT_SWMP9_CLIP_02`, `COMPONENT_P80_CLIP_02`, `COMPONENT_glock19xs_CLIP_02`, `COMPONENT_Glock19P80_CLIP_02`,
        `COMPONENT_M45A1FM_CLIP_02`, `COMPONENT_SIG_CLIP_02`, `COMPONENT_M17_CLIP_02`, `COMPONENT_FNX45_CLIP_02`,
        `COMPONENT_GHOSTGLOCK_CLIP_02`, `COMPONENT_TAURUSG2C_CLIP_02`, `COMPONENT_TX22_CLIP_02`,
    },

    ['at_clip_extended_smg'] = { `w_sb_hfsmg_mag2`, `COMPONENT_MP7_CLIP_02`, `COMPONENT_MP9_CLIP_02`, `COMPONENT_MAC11_CLIP_02`, `COMPONENT_VECTOR_CLIP_02` },

    ['at_clip_extended_rifle'] = {
        `COMPONENT_ADVANCEDRIFLE_CLIP_02`, `COMPONENT_ASSAULTRIFLE_CLIP_02`, `COMPONENT_ASSAULTRIFLE_MK2_CLIP_02`,
        `COMPONENT_BULLPUPRIFLE_CLIP_02`, `COMPONENT_BULLPUPRIFLE_MK2_CLIP_02`, `COMPONENT_CARBINERIFLE_CLIP_02`,
        `COMPONENT_CARBINERIFLE_MK2_CLIP_02`, `COMPONENT_COMPACTRIFLE_CLIP_02`, `COMPONENT_HEAVYRIFLE_CLIP_02`,
        `COMPONENT_MILITARYRIFLE_CLIP_02`, `COMPONENT_SPECIALCARBINE_CLIP_02`, `COMPONENT_SPECIALCARBINE_MK2_CLIP_02`,
        `COMPONENT_TACTICALRIFLE_CLIP_02`, `COMPONENT_CARBINERIFLE_BOXMAG`, `COMPONENT_ARPISTOL_BOXMAG`,
        `COMPONENT_PLR_CLIP_02`, `COMPONENT_BARP_CLIP_02`, `w_ar_drh_mag2`, `w_ar_arc15_mag2`, `w_ar_grau_mag2`,
        `w_ar_jrbak_mag2`, `w_ar_m133_mag2`, `COMPONENT_ARP_CLIP_02`, `w_ar_neva_mag2`, `COMPONENT_AKM_CLIP_06`,
        `COMPONENT_SR25_CLIP_01`, `COMPONENT_M4A1FM_CLIP_03`, `COMPONENT_MDR2_CLIP_06`, `COMPONENT_DRACO_CLIP_02`,
    },

    ['at_scope_medium'] = {
        `COMPONENT_AT_SCOPE_MEDIUM`, `COMPONENT_AT_ARPISTOLSCOPE_MEDIUM`, `COMPONENT_AT_SCOPE_MEDIUM_MK2`,
        `w_at_ar_drh_scope`, `w_at_ar_arc15_scope`, `w_at_ar_grau_scope`, `w_at_ar_jrbak_scope`, `w_at_ar_m133_scope`,
        `w_at_ar_neva_scope`, `COMPONENT_AKM_SCOPE_01`, `w_at_sb_hfsmg_scope`, `COMPONENT_SR25_SCOPE_09`,
        `COMPONENT_M4A1FM_SCOPE_04`, `COMPONENT_MDR2_SCOPE_04`, `COMPONENT_AT_SCOPE_MACRO_MP7`,
        `COMPONENT_AT_SCOPE_MCX`, `COMPONENT_AT_SCOPE_MP9`,
    },

    ['at_scope_large'] = { `COMPONENT_AT_SCOPE_LARGE_MK2`, `COMPONENT_AT_SCOPE_LARGE`, `COMPONENT_M4A1FM_SCOPE_02` },

    ['at_clip_drum_pistol'] = {
        `COMPONENT_GLOCK19X_CLIP_03`, `COMPONENT_GLOCK19_CLIP_03`, `COMPONENT_COMBATPISTOL_CLIP_03`,
        `COMPONENT_GLOCK40_CLIP_03`, `COMPONENT_GLOCK18C_CLIP_03`, `COMPONENT_GLOCK21_CLIP_02`,
        `COMPONENT_GLOCK17GS_CLIP_02`, `COMPONENT_GLOCK26_CLIP_02`, `COMPONENT_GLOCK17_DRUM`, `COMPONENT_GLOCK22_CLIP_02`,
    },

    ['at_clip_drum_smg'] = { `COMPONENT_MP5SD_CLIP_02` },

    ['at_clip_100_pistol'] = { `COMPONENT_GLOCK19X_CLIP_04`, `COMPONENT_GLOCK40_CLIP_04`, `COMPONENT_COMBATPISTOL_CLIP_04` },

    ['at_clip_100_rifle'] = {
        `COMPONENT_ARP_BOXMAG`, `COMPONENT_AKM_CLIP_09`, `COMPONENT_MDR2_CLIP_07`, `COMPONENT_shoulderstraparp_CLIP_02`,
        `COMPONENT_MCX_CLIP_02`, `COMPONENT_AK47_CLIP_02`, `COMPONENT_AK74_CLIP_02`,
    },

    ['sigsauerextendedclip'] = { `p226mag2` },
    ['macextendedclip'] = { `COMPONENT_MAC10_CLIP_02` },

    ['glockextendedclip'] = { `w_pi_g18_mag2`, `glock40mag2`, `glock26mag2`, `glock30mag2`, `glock17mag2`, `glock19mag2`, `g26mag2`, `glock19xmag2`, `glock43x2` },
    ['glockextendedclipclear'] = { `glock40mag4`, `glock26mag4`, `glock30mag4`, `glock17mag4`, `glock19mag4`, `g26mag4`, `glock19xmag4`, `glock43x4` },
    ['springfieldextendedclip'] = { `springfieldmag2`, `mpmag2` },
    ['glockdrumclip'] = { `w_pi_g18_mag3`, `glock40mag3`, `glock26mag3`, `glock30mag3`, `glock17mag3`, `glock19mag3`, `glock19xmag3` },
    ['arpistoldrum'] = { `COMPONENT_ARPISTOL_CLIP_02` },

    ['dd_clip'] = { `COMPONENT_PMAGLINK_B` },
    ['dd_suppressor'] = { `COMPONENT_SOCOMSUP14_B` },
    ['dd_scope'] = { `COMPONENT_EXPS34_B` },
    ['dd_grip'] = { `COMPONENT_BCM_B` },
    ['dd_flashlight'] = { `COMPONENT_PEQ14_B` },
    ['dd_peq'] = { `COMPONENT_PEQ14_B` },
}
