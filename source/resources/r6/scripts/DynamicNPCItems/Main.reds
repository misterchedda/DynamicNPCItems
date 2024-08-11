module MisterChedda.DynamicNPCItems
import MisterChedda.DynamicNPCItems.*

/*
TODO
Implement dynamic materials here or separate mod
*/
public class NPCCrowdWeatherListener extends WeatherScriptListener {
    private let m_owner: wref<NPCCrowdItems>;

    public final func Initialize(owner: ref<NPCCrowdItems>) -> Void {
        this.m_owner = owner;
    }

    public func OnRainIntensityChanged(rainIntensity: Float) {
        if IsDefined(this.m_owner) {
            this.m_owner.TriggerUmbrellas(rainIntensity);
        }
    }
}


public class NPCCrowdItems extends ScriptableSystem {
    private let m_modSettings: ref<DynamicNPCItemSettings>;
    private let validLocomotions: array<CName>;

    private let multilayered_shader: ResourceRef;
    private let tabletMatSetup0: ResourceRef;
    private let tabletMatSetup1: ResourceRef;
    private let tabletMatSetup2: ResourceRef;
    private let tabletMatSetup3: ResourceRef;
    private let tabletMatSetup4: ResourceRef;

    private let tabletMaskSetup1: ResourceRef;

    private let tabletTexture0: ResourceRef;
    private let tabletTexture1: ResourceRef;
    private let tabletTexture2: ResourceRef;
    private let tabletTexture3: ResourceRef;


    private let screenUITexture: ResourceRef;
    private let metalbaseTexture: ResourceRef;
    private let blackTexture: ResourceRef;
    private let screenFluffTexture: ResourceRef;
    private let dynMat1: ref<CMaterialInstance>;
    private let dynMat2: ref<CMaterialInstance>;

    private let cellphoneMatSetup: ResourceRef;
    private let cellphoneMatSetup1: ResourceRef;
    private let cellphoneMatSetup2: ResourceRef;
    
    private let cellphoneMaskSetup: ResourceRef;
    private let cellphoneNormal: ResourceRef;
    private let screenUIShader: ResourceRef;
    private let displayTexture: ResourceRef;
    private let displayTexture1: ResourceRef;
    private let displayTexture2: ResourceRef;
    private let dynMatBody: ref<CMaterialInstance>;
    private let dynMatScreen: ref<CMaterialInstance>;

    private let randomAppearances: array<CName>;
    private let randomPhoneAppearances: array<CName>;
    private let randomTabletAppearances: array<CName>;
    private let randomPurseAppearances: array<CName>;

    private let allPossibleItems: array<ItemID>;

    private let m_weatherCallbackId: Uint32;
    private let m_weatherListener: ref<NPCCrowdWeatherListener>;
    
    private let whiteTexture: ResourceRef;
    private let umbrellaMatInstances: array<ref<CMaterialInstance>>;
    private let currentUmbrellaMatIndex: Int32;

    private func OnAttach() {
        this.m_modSettings = DynamicNPCItemSettings.Get(GetGameInstance());
        ModSettings.RegisterListenerToModifications(this);
        ModSettings.RegisterListenerToClass(this);

        this.randomAppearances = [n"int_accessories_001__duffel_bag_item_appearance_1", n"int_accessories_001__duffel_bag_item_appearance_0", n"int_accessories_001__duffel_bag_item_appearance_2", n"int_accessories_001__duffel_bag_item_appearance_3", n"int_accessories_001__duffel_bag_item_appearance_4"];
        this.randomPhoneAppearances = [n"int_accessories_cellphone_0", n"int_accessories_cellphone_1", n"int_accessories_cellphone_2", n"int_accessories_cellphone_3", n"int_accessories_cellphone_4", n"int_accessories_cellphone_5"];
        this.randomTabletAppearances = [n"int_electronics_001__tablet_d_neo_kistch_item_appearance_0", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_1", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_2", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_3", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_4", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_5", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_6", n"int_electronics_001__tablet_d_neo_kistch_item_appearance_7"];
        this.randomPurseAppearances = [n"int_accessories_001__purse_item_appearance_4", n"int_accessories_001__purse_item_appearance_0", n"int_accessories_001__purse_item_appearance_1", n"int_accessories_001__purse_item_appearance_2", n"int_accessories_001__purse_item_appearance_3"];

        this.validLocomotions = [
            n"TabletLocomotion",
            n"CellphoneLocomotion",
            n"CellphoneTalkingLocomotion",
            n"PurseLocomotion",
            n"DufflebagLocomotion",
            n"LaptopbagLocomotion",
            n"CanLocomotion",
            n"CigaretteLocomotion",
            n"UmbrellaLocomotion"
        ];
        this.m_weatherListener = new NPCCrowdWeatherListener();
        this.m_weatherListener.Initialize(this);
        this.m_weatherCallbackId = GameInstance.GetWeatherSystem(GetGameInstance()).RegisterWeatherListener(this.m_weatherListener);


        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_tablet_d_neo_kistch")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_purse")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_int_apparel_002__umbrella_small")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_cellphone")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.crowd_talking_cellphone")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_duffle_bag")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_cigarette_i_stick")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_laptop_bag")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_delivery_crate_d")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_soda_can_a")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_soda_can_b")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_soda_can_c")));
        ArrayPush(this.allPossibleItems, ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_bottle_e_beer")));
  
        
        this.multilayered_shader *= r"engine\\materials\\multilayered.mt";

        this.tabletMatSetup0 *= r"base\\environment\\decoration\\electronics\\devices\\tablet\\textures\\ml_tablet_d_neo_kistch.mlsetup";
        this.tabletMatSetup1 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_tablet_d_neo_kistch.mlsetup";
        this.tabletMatSetup2 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_tablet_d_neo_kistch_blue.mlsetup";
        this.tabletMatSetup3 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_tablet_d_neo_kistch_light.mlsetup";
        this.tabletMatSetup4 *= r"base\\environment\\decoration\\electronics\\devices\\tablet\\textures\\ml_tablet_b_kitsch.mlsetup";

        this.tabletMaskSetup1 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_tablet_d_neo_kistch_masksset.mlmask";

        this.tabletTexture0 *= r"base\\environment\\decoration\\electronics\\devices\\tablet\\textures\\civ_16x9_neokitch_2.xbm";
        this.tabletTexture1 *= r"base\\surfaces\\textures\\screens\\generic\\colorless\\10_civil_medium_16x9.xbm";
        this.tabletTexture2 *= r"base\\surfaces\\textures\\screens\\generic\\colorless\\06_civil_16x9_gold.xbm";
        this.tabletTexture3 *= r"base\\surfaces\\textures\\screens\\generic\\colorless\\28_industry_small_16x9.xbm";

        // this.screenUITexture  *= r"base\\materials\\screen\\screen_ui.mi";
        this.metalbaseTexture  *= r"engine\\materials\\metal_base.remt";
        // this.blackTexture  *= r"engine\\textures\\editor\\black.xbm";
        this.screenFluffTexture  *= r"base\\materials\\screen\\screen_fluff_fullcolor.mi";

        this.cellphoneMatSetup *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_int_accessories_001__cellphone.mlsetup";
        this.cellphoneMaskSetup *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_int_accessories_001__cellphone_masksset.mlmask";
        this.cellphoneNormal *= r"misterchedda\\DynamicNPCItems\\items\\mat\\int_accessories_001__cellphone_n01.xbm";
        this.screenUIShader *= r"base\\materials\\screen\\screen_ui.mi";
        this.displayTexture *= r"base\\surfaces\\textures\\screens\\generic\\display_block_05.xbm";
        this.displayTexture1 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\display_block_01.xbm";
        this.displayTexture2 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\display_block_04.xbm";
        this.cellphoneMatSetup1 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_int_accessories_001__cellphone_light.mlsetup";
        this.cellphoneMatSetup2 *= r"misterchedda\\DynamicNPCItems\\items\\mat\\ml_int_accessories_001__cellphone_blue.mlsetup";



        this.dynMatBody = new CMaterialInstance();
        this.dynMatScreen = new CMaterialInstance();

        this.dynMat1 = new CMaterialInstance();
        this.dynMat2 = new CMaterialInstance();

        // GameInstance.GetCallbackSystem().RegisterCallback(n"Resource/Ready", this, n"ProcessTablet")
        //     .AddTarget(ResourceTarget.Path(r"base\\environment\\decoration\\electronics\\devices\\tablet\\tablet_d_neo_kistch.mesh"));

        // GameInstance.GetCallbackSystem().RegisterCallback(n"Resource/Ready", this, n"ProcessPhone")
        //     .AddTarget(ResourceTarget.Path(r"base\\items\\interactive\\accessories\\int_accessories_001__cellphone\\int_accessories_001__cellphone.mesh"));

        this.whiteTexture *= r"engine\\textures\\editor\\white.xbm";
        this.umbrellaMatInstances = [];
        this.currentUmbrellaMatIndex = 0;

        // GameInstance.GetCallbackSystem().RegisterCallback(n"Resource/Ready", this, n"ProcessUmbrellaMesh")
        //     .AddTarget(ResourceTarget.Path(r"base\\items\\interactive\\apparel\\int_apparel_002_umbrella_multi\\int_apparel_002__umbrella_multi.mesh"));


       GameInstance.GetCallbackSystem()
            .RegisterCallback(n"Entity/Attached", this, n"OnNPCSpawned")
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen_ep1_scrapper_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen_ep1_scrapper_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_aldecaldos_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_aldecaldos_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_aldecaldos_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_arasaka_corpo_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_arasaka_corpo_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_biker_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_biker_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_children_mc.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_chubby_waf.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_barghest_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_barghest_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_barghest_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_business_crowd_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_business_crowd_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_business_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_business_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_carrying_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_carrying_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_droid.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_nightlife_crowd_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_nightlife_crowd_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_nightlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_nightlife_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_obese_mf.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_obese_pacific_mf.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_obese_waf.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_outcast_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_outcast_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_pacific_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_pacific_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_pacific_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_elder_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_elder_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_lowlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_lowlife_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_mc.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_worker_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_combat_zone_stacks_worker_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_corporat_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_corporat_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_corporat_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_creole_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_creole_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_creole_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_default_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_default_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_freak_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_freak_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_homeless_man.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_homeless_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_homeless_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_junkie_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_junkie_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_lowlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_lowlife_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_lowlife_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_mallrat_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_nightlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_nightlife_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_nonbinary_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_nonbinary_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_obese_mf.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_rich_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_rich_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_tenant_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_tenant_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_tenant_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_workout_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_workout_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_workout_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_youngster_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_youngster_mb.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\citizen__ep1_youngster_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\tga_trailer_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\citizen\\tga_trailer_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen_nightlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen_nonbinary_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen_nonbinary_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__aldecaldos_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__aldecaldos_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__aldecaldos_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__arasaka_corpo_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__arasaka_corpo_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__biker_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__biker_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__children_mc.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__chubby_waf.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__chubby_waf__local.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__corporat_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__corporat_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__corporat_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__creole_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__creole_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__creole_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__default_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__default_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__freak_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__freak_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__homeless_man.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__homeless_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__homeless_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__junkie_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__junkie_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__lowlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__lowlife_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__lowlife_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__mallrat_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__nightlife_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__nightlife_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__nightlife_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__obese_mf.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__rich_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__rich_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__tenant_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__tenant_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__tenant_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__workout_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__workout_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__workout_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__youngster_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__youngster_mb.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\citizen\\citizen__youngster_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\service\\service__ep1_medical_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\service\\service__ep1_medical_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\service\\service__ep1_religious_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\service\\service__ep1_religious_ma.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\service\\service__ep1_sexworker_wa.ent"))
            .AddTarget(EntityTarget.Template(r"ep1\\characters\\entities\\service\\service__ep1_sexworker_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\service\\service__ep1_medical_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\service\\service__ep1_medical_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\service\\service__ep1_religious_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\service\\service__ep1_religious_ma.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\service\\service__ep1_sexworker_wa.ent"))
            .AddTarget(EntityTarget.Template(r"base\\characters\\entities\\service\\service__ep1_sexworker_ma.ent"));
    }

    private func OnDetach() -> Void {
        ModSettings.UnregisterListenerToClass(this);
        ModSettings.UnregisterListenerToModifications(this);
        GameInstance.GetWeatherSystem(GetGameInstance()).UnregisterWeatherListener(this.m_weatherCallbackId);
        this.m_weatherListener = null;

    }


    public func TriggerUmbrellas(rainIntensity: Float) -> Void {
        // LogChannel(n"DEBUG", s"TriggerUmbrellas called with rain intensity: \(rainIntensity)");

        if rainIntensity <= 0.01 {
            // No rain, revert to original state
            this.validLocomotions = [
                n"TabletLocomotion",
                n"CellphoneLocomotion",
                n"CellphoneTalkingLocomotion",
                n"PurseLocomotion",
                n"DufflebagLocomotion",
                n"LaptopbagLocomotion",
                n"CanLocomotion",
                n"CigaretteLocomotion",
                n"UmbrellaLocomotion"
            ];

            this.m_modSettings.useUmbrella = false;
            this.m_modSettings.useBag = true;
            this.m_modSettings.useCellphoneTablet = true;
            this.m_modSettings.useCan = true;
            this.m_modSettings.useCigarette = true;
        } else if rainIntensity < 0.5 {
            // Light rain
            this.validLocomotions = [
                n"UmbrellaLocomotion",
                n"PurseLocomotion",
                n"DufflebagLocomotion",
                n"LaptopbagLocomotion",
                n"CellphoneLocomotion",
                n"CellphoneTalkingLocomotion"
            ];

            this.m_modSettings.useUmbrella = true;
            this.m_modSettings.useBag = true;
            this.m_modSettings.useCellphoneTablet = true;
            this.m_modSettings.useCan = false;
            this.m_modSettings.useCigarette = false;
        } else if rainIntensity < 0.92 {
            // Medium rain
            this.validLocomotions = [
                n"UmbrellaLocomotion",
                n"PurseLocomotion",
                n"DufflebagLocomotion",
                n"LaptopbagLocomotion"
            ];

            this.m_modSettings.useUmbrella = true;
            this.m_modSettings.useBag = true;
            this.m_modSettings.useCellphoneTablet = false;
            this.m_modSettings.useCan = false;
            this.m_modSettings.useCigarette = false;
        } else {
            // Heavy rain
            this.validLocomotions = [
                n"UmbrellaLocomotion"
            ];

            this.m_modSettings.useUmbrella = true;
            this.m_modSettings.useBag = false;
            this.m_modSettings.useCellphoneTablet = false;
            this.m_modSettings.useCan = false;
            this.m_modSettings.useCigarette = false;
        }

        // LogChannel(n"DEBUG", s"Updated validLocomotions: \(this.validLocomotions)");
        // LogChannel(n"DEBUG", s"Updated mod settings: useUmbrella=\(this.m_modSettings.useUmbrella), useBag=\(this.m_modSettings.useBag), useCellphoneTablet=\(this.m_modSettings.useCellphoneTablet), useCan=\(this.m_modSettings.useCan), useCigarette=\(this.m_modSettings.useCigarette)");
    }

    private func CreateTableMat(materialName: CName) -> ref<CMaterialInstance> {
        let dynMat = new CMaterialInstance();

        if Equals(materialName, n"ml_tablet_d_neo_kistch_masksset") { 
            dynMat.baseMaterial = this.multilayered_shader;
            let miParams: array<MaterialParameterInstance>;
            let rand = RandRange(0,5);
            if rand == 0 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.tabletMatSetup0, n"rRef:Multilayer_Setup")));
            } else if rand == 1 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.tabletMatSetup1, n"rRef:Multilayer_Setup")));
            } else if rand == 2 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.tabletMatSetup2, n"rRef:Multilayer_Setup")));
            } else if rand == 3 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.tabletMatSetup3, n"rRef:Multilayer_Setup")));
            } else {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.tabletMatSetup4, n"rRef:Multilayer_Setup")));
            }
            ArrayPush(miParams, this.GenerateParam(n"MultilayerMask", ResourceRef.ToVariant(this.tabletMaskSetup1, n"rRef:Multilayer_Mask")));
            dynMat.params = miParams;
        } else if Equals(materialName, n"screen_fluff_horizontal") {
            dynMat.baseMaterial = this.screenFluffTexture;
            let miParams: array<MaterialParameterInstance>;
            let rand = RandRange(0,4);
            if rand == 0 {
                ArrayPush(miParams, this.GenerateParam(n"ParalaxTexture", ResourceRef.ToVariant(this.tabletTexture0, n"rRef:ITexture")));
            } else if rand == 1 {
                ArrayPush(miParams, this.GenerateParam(n"ParalaxTexture", ResourceRef.ToVariant(this.tabletTexture1, n"rRef:ITexture")));
            } else if rand == 2 {
                ArrayPush(miParams, this.GenerateParam(n"ParalaxTexture", ResourceRef.ToVariant(this.tabletTexture2, n"rRef:ITexture")));
            } else {
                ArrayPush(miParams, this.GenerateParam(n"ParalaxTexture", ResourceRef.ToVariant(this.tabletTexture3, n"rRef:ITexture")));
            }
            dynMat.params = miParams;
        }
        return dynMat;
    }


    private func CreateCellphoneMat(materialName: CName) -> ref<CMaterialInstance> {
        let dynMat = new CMaterialInstance();

        if Equals(materialName, n"ml_int_accessories_001__cellphone_masksset") { 
            dynMat.baseMaterial = this.multilayered_shader;
            let miParams: array<MaterialParameterInstance>;
            let rand = RandRange(0,3);
            if rand == 0 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.cellphoneMatSetup, n"rRef:Multilayer_Setup")));
            } else if rand == 1 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.cellphoneMatSetup1, n"rRef:Multilayer_Setup")));
            } else if rand == 2 {
                ArrayPush(miParams, this.GenerateParam(n"MultilayerSetup", ResourceRef.ToVariant(this.cellphoneMatSetup2, n"rRef:Multilayer_Setup")));
            }
            ArrayPush(miParams, this.GenerateParam(n"MultilayerMask", ResourceRef.ToVariant(this.cellphoneMaskSetup, n"rRef:Multilayer_Mask")));
            ArrayPush(miParams, this.GenerateParam(n"GlobalNormal", ResourceRef.ToVariant(this.cellphoneNormal, n"rRef:ITexture")));
            dynMat.params = miParams;
        } 
        else if Equals(materialName, n"display") {
            dynMat.baseMaterial = this.screenUIShader;
            let miParams: array<MaterialParameterInstance>;

            let rand = RandRange(0,3);
            if rand == 0 {
                ArrayPush(miParams, this.GenerateParam(n"UIRenderTexture", ResourceRef.ToVariant(this.displayTexture, n"rRef:ITexture")));
            } else if rand == 1 {
                ArrayPush(miParams, this.GenerateParam(n"UIRenderTexture", ResourceRef.ToVariant(this.displayTexture1, n"rRef:ITexture")));
            } else {
                ArrayPush(miParams, this.GenerateParam(n"UIRenderTexture", ResourceRef.ToVariant(this.displayTexture2, n"rRef:ITexture")));
            }
            ArrayPush(miParams, this.GenerateParam(n"VerticalFlipEnabled", ToVariant(1.0)));
            ArrayPush(miParams, this.GenerateParam(n"Tint", ToVariant(new Color(Cast<Uint8>(RandRange(0,25)), Cast<Uint8>(RandRange(148, 220)), Cast<Uint8>(RandRange(150,249)), Cast<Uint8>(255)))));
            ArrayPush(miParams, this.GenerateParam(n"EmissiveEV", ToVariant(8.0)));
            dynMat.params = miParams;
        }
        return dynMat;
    }

    private cb func ProcessPhone(event: ref<ResourceEvent>) {
        let phoneMesh = event.GetResource() as CMesh;
        // logchannel(n"DEBUG", s"ProcessPhone called");
        if !IsDefined(phoneMesh)
        {
            return;
        }
        let i = 0;
        while i < ArraySize(phoneMesh.materialEntries) {
            let materialName = phoneMesh.materialEntries[i].name;
            if Equals(materialName, n"ml_int_accessories_001__cellphone_masksset") {
                // logchannel(n"DEBUG", s"ProcessPhone: Processing body material");
                this.dynMatBody = this.CreateCellphoneMat(materialName);
                phoneMesh.materialEntries[i].material = this.dynMatBody;
            } 
            else if Equals(materialName, n"display") {
                // logchannel(n"DEBUG", s"ProcessPhone: Processing display material");
                this.dynMatScreen = this.CreateCellphoneMat(materialName);
                phoneMesh.materialEntries[i].material = this.dynMatScreen;
            }
            i += 1;
        }
    } 

    private cb func ProcessTablet(event: ref<ResourceEvent>) {
        let neonMesh = event.GetResource() as CMesh;
        // logchannel(n"DEBUG", s"ProcessTablet !!!!!!! called");

        let i = 0;
        while i < ArraySize(neonMesh.materialEntries) {
            let materialName = neonMesh.materialEntries[i].name;
            if Equals(materialName, n"ml_tablet_d_neo_kistch_masksset") {
                // logchannel(n"DEBUG", s"ProcessTablet !!!!!!! called matn ame === \(materialName)");

                this.dynMat1 = this.CreateTableMat(materialName);
                neonMesh.materialEntries[i].material = this.dynMat1;
            } else if  Equals(materialName, n"screen_fluff_horizontal")  {
                this.dynMat2 = this.CreateTableMat(materialName);
                neonMesh.materialEntries[i].material = this.dynMat2;
            }

            i += 1;
        }
        
    }

    private func CreateRandomColorMaterial(materialName: CName) -> ref<CMaterialInstance> {
        let dynMat = new CMaterialInstance();

        dynMat.baseMaterial = this.metalbaseTexture;

        let miParams: array<MaterialParameterInstance>;
        ArrayPush(miParams, this.GenerateParam(n"BaseColorScale", ToVariant(new Vector4(1.0, 1.0, 1.0, 1.0))));
        ArrayPush(miParams, this.GenerateParam(n"BaseColor", ResourceRef.ToVariant(this.whiteTexture, n"rRef:ITexture")));
        ArrayPush(miParams, this.GenerateRandomColorParam(n"EmissiveColor"));
        ArrayPush(miParams, this.GenerateParam(n"Emissive", ResourceRef.ToVariant(this.whiteTexture, n"rRef:ITexture")));
        ArrayPush(miParams, this.GenerateFloatParam(n"EmissiveEV", 10.0));

        dynMat.params = miParams;

        ArrayPush(this.umbrellaMatInstances, dynMat);
        return dynMat;
    }

    private cb func ProcessUmbrellaMesh(event: ref<ResourceEvent>) {
        let umbrellaMesh = event.GetResource() as CMesh;
        if !IsDefined(umbrellaMesh) {
            return;
        }

        let i = 0;
        while i < ArraySize(umbrellaMesh.materialEntries) {
            let materialName = umbrellaMesh.materialEntries[i].name;
            if StrBeginsWith(ToString(materialName), "neon") {
                let dynMat = this.CreateRandomColorMaterial(materialName);
                umbrellaMesh.materialEntries[i].material = dynMat;
                
                if this.currentUmbrellaMatIndex >= 150 {
                    this.currentUmbrellaMatIndex = 0;
                } else {
                    this.currentUmbrellaMatIndex += 1;
                }
            }
            i += 1;
        }
    }

    private func GenerateParam(paramName: CName, paramData: Variant) -> MaterialParameterInstance {
        let param: MaterialParameterInstance;
        param.name = paramName;
        param.data = paramData;
        return param;
    }

    private func GenerateFloatParam(paramName: CName, value: Float) -> MaterialParameterInstance {
        return this.GenerateParam(paramName, ToVariant(value));
    }

    private func GenerateRandomColorParam(paramName: CName) -> MaterialParameterInstance {
        let randomColor = new Color(
            Cast<Uint8>(RandRange(0, 256)), 
            Cast<Uint8>(RandRange(0, 256)), 
            Cast<Uint8>(RandRange(0, 256)), 
             Cast<Uint8>(255)
        );
        return this.GenerateParam(paramName, ToVariant(randomColor));
    }

    private func SelectLocomotionBasedOnPreference(availableLocomotions: array<CName>) -> CName {
        let enabledLocomotions: array<CName> = [];

        for locomotion in availableLocomotions {
            if this.IsLocomotionEnabled(locomotion) {
                ArrayPush(enabledLocomotions, locomotion);
            }
        }
        if ArraySize(enabledLocomotions) > 0 {
            let selected = enabledLocomotions[RandRange(0, ArraySize(enabledLocomotions))];
            return selected;
        } else {
            return enabledLocomotions[RandRange(0, ArraySize(enabledLocomotions))];
        }
    }

    private func IsLocomotionEnabled(locomotion: CName) -> Bool {
        // LogChannel(n"DEBUG", s"IsLocomotionEnabled ==> Cellphne: \(this.m_modSettings.useCellphoneTablet) | bag: \(this.m_modSettings.useBag) | umbrella: \(this.m_modSettings.useUmbrella)");
        if Equals(locomotion, n"TabletLocomotion") || Equals(locomotion, n"CellphoneLocomotion") || Equals(locomotion, n"CellphoneTalkingLocomotion") {
            return this.m_modSettings.useCellphoneTablet;
        } else if Equals(locomotion, n"PurseLocomotion") || Equals(locomotion, n"DufflebagLocomotion") || Equals(locomotion, n"LaptopbagLocomotion") {
            return this.m_modSettings.useBag;
        } else if Equals(locomotion, n"CanLocomotion") {
            return this.m_modSettings.useCan;
        } else if Equals(locomotion, n"CigaretteLocomotion") {
            return this.m_modSettings.useCigarette;
        } else if Equals(locomotion, n"UmbrellaLocomotion") {
            let isEnabled = this.m_modSettings.useUmbrella;
            // LogChannel(n"DEBUG", s"Umbrella locomotion enabled: \(isEnabled)");
            return isEnabled;
        } else {
            return false;
        }
    }
    private func GetItemIDForLocomotion(locomotion: CName) -> ItemID {
        if Equals(locomotion, n"TabletLocomotion") {
            let items = ["Items.locomotion_crowd_tablet_d_neo_kistch"];
            return ItemID.FromTDBID(TDBID.Create(items[RandRange(0, ArraySize(items))]));
        } else if Equals(locomotion, n"PurseLocomotion") {
            return ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_purse"));
        } else if Equals(locomotion, n"UmbrellaLocomotion") {
            return ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_int_apparel_002__umbrella_small"));
        } else if Equals(locomotion, n"CellphoneLocomotion") {
            return ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_cellphone"));
        } else if Equals(locomotion, n"CellphoneTalkingLocomotion") {
            return ItemID.FromTDBID(TDBID.Create("Items.crowd_talking_cellphone"));
        } else if Equals(locomotion, n"DufflebagLocomotion") {
            let items = ["Items.locomotion_crowd_duffle_bag"];
            return ItemID.FromTDBID(TDBID.Create(items[RandRange(0, ArraySize(items))]));
        } else if Equals(locomotion, n"CigaretteLocomotion") {
            return ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_cigarette_i_stick"));
        } else if Equals(locomotion, n"LaptopbagLocomotion") {
            let items = ["Items.locomotion_crowd_laptop_bag"];
            return ItemID.FromTDBID(TDBID.Create(items[RandRange(0, ArraySize(items))]));
        } else if Equals(locomotion, n"CrateLocomotion") {
            return ItemID.FromTDBID(TDBID.Create("Items.locomotion_crowd_delivery_crate_d"));
        } else if Equals(locomotion, n"CanLocomotion") {
            let items = ["Items.locomotion_crowd_soda_can_a", "Items.locomotion_crowd_soda_can_b", "Items.locomotion_crowd_soda_can_c", "Items.locomotion_crowd_bottle_e_beer"];
            return ItemID.FromTDBID(TDBID.Create(items[RandRange(0, ArraySize(items))]));
        } else {
            return ItemID.None();
        }
    }

    private cb func OnNPCSpawned(event: ref<EntityLifecycleEvent>) {
        if !this.m_modSettings.enabled || RandF() * 100.0 > this.m_modSettings.itemFrequency {
            return;
        }
        let entity = event.GetEntity() as ScriptedPuppet;
        if !IsDefined(entity) {
            return;
        }
        let txnSystem = GameInstance.GetTransactionSystem(GetGameInstance());
        if GameInstance.GetWorkspotSystem((entity as ScriptedPuppet).GetGame()).IsActorInWorkspot((entity as ScriptedPuppet)) {
            return;
        }
        let sceneSystemInt: ref<SceneSystemInterface> = GameInstance.GetSceneSystem(GetGameInstance()).GetScriptInterface();
        if IsDefined(sceneSystemInt) {
            if (sceneSystemInt.IsEntityInScene(entity.GetEntityID())) {
                return;
            }
        }
        let components = entity.GetComponents();
        let availableLocomotions: array<CName> = [];

        for comp in components {
            let specialLocoMotionComp = comp as entAnimationSetupExtensionComponent;
            if IsDefined(specialLocoMotionComp) {
                for animSet in specialLocoMotionComp.animations.gameplay {
                    for varName in animSet.variableNames {
                        if ArrayContains(this.validLocomotions, varName) {
                            ArrayPush(availableLocomotions, varName);
                        }
                    }
                }
            }
        }

        if ArraySize(availableLocomotions) > 0 {
            let selectedLocomotion = this.SelectLocomotionBasedOnPreference(availableLocomotions);
            let itemID = this.GetItemIDForLocomotion(selectedLocomotion);
            if ItemID.IsValid(itemID) {
                if IsDefined(txnSystem) {
                    // Check if the NPC already has any of the possible items in any slot
                    let hasAnyItem = false;

                    let existingItem: ItemID;
                    
                    let i = 0;
                    while i < ArraySize(this.allPossibleItems) {
                        if txnSystem.HasItemInAnySlot(entity, this.allPossibleItems[i]) {
                            hasAnyItem = true;
                            existingItem = this.allPossibleItems[i];
                            break;
                        }
                        i += 1;
                    }
                    let itemstr = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).FriendlyName();

                    txnSystem.RemoveAllItems(entity);

                    if !hasAnyItem {
                        if txnSystem.GiveItem(entity, itemID, 1) {
                            // LogChannel(n"DEBUG", s"ITEM ATTACHED ===== \(itemstr)");
                            let slotChoice = RandF();
                            let slotToUse: TweakDBID;
                            // LogChannel(n"DEBUG", s"NO ITEM FOUND ON SLOT! EQUPPING NEW");
                            if slotChoice <= 0.8 {
                                slotToUse = t"AttachmentSlots.WeaponRight";
                            } else {
                                slotToUse = t"AttachmentSlots.WeaponLeft";
                            }
                            if Equals(selectedLocomotion, n"DufflebagLocomotion") {
                                let randomApp = this.randomAppearances[RandRange(0, 5)];
                                txnSystem.AddItemToSlot(entity, slotToUse, itemID, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                                txnSystem.ChangeItemAppearanceByName(entity, itemID, randomApp);
                            } else if Equals(selectedLocomotion, n"CellphoneLocomotion") {
                                let randomApp = this.randomPhoneAppearances[RandRange(0, 3)];
                                txnSystem.AddItemToSlot(entity, slotToUse, itemID, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                                txnSystem.ChangeItemAppearanceByName(entity, itemID, randomApp);
                            } else if Equals(selectedLocomotion, n"TabletLocomotion") {
                                let randomApp = this.randomTabletAppearances[RandRange(0, 8)];
                                txnSystem.AddItemToSlot(entity, slotToUse, itemID, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                                txnSystem.ChangeItemAppearanceByName(entity, itemID, randomApp);
                            } else if Equals(selectedLocomotion, n"PurseLocomotion") {
                                let randomApp = this.randomPurseAppearances[RandRange(0, 5)];
                                txnSystem.AddItemToSlot(entity, slotToUse, itemID, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                                txnSystem.ChangeItemAppearanceByName(entity, itemID, randomApp);
                            } else {
                                txnSystem.AddItemToSlot(entity, slotToUse, itemID, true);
                            }
                        }
                    } else {
                        let slotChoice = RandF();
                        let slotToUse: TweakDBID;
                        // LogChannel(n"DEBUG", s"ITEM FOUND ON SLOT! EQUPPING EXISTING");
                        if slotChoice <= 0.8 {
                            slotToUse = t"AttachmentSlots.WeaponRight";
                        } else {
                            slotToUse = t"AttachmentSlots.WeaponLeft";
                        }
                        if Equals(selectedLocomotion, n"DufflebagLocomotion") {
                            let randomApp = this.randomAppearances[RandRange(0, 5)];
                            txnSystem.AddItemToSlot(entity, slotToUse, existingItem, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                            txnSystem.ChangeItemAppearanceByName(entity, existingItem, randomApp);
                        } else if Equals(selectedLocomotion, n"CellphoneLocomotion") {
                            let randomApp = this.randomPhoneAppearances[RandRange(0, 3)];
                            txnSystem.AddItemToSlot(entity, slotToUse, existingItem, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                            txnSystem.ChangeItemAppearanceByName(entity, existingItem, randomApp);
                        } else if Equals(selectedLocomotion, n"TabletLocomotion") {
                            let randomApp = this.randomTabletAppearances[RandRange(0, 8)];
                            txnSystem.AddItemToSlot(entity, slotToUse, existingItem, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                            txnSystem.ChangeItemAppearanceByName(entity, existingItem, randomApp);
                        } else if Equals(selectedLocomotion, n"PurseLocomotion") {
                            let randomApp = this.randomPurseAppearances[RandRange(0, 5)];
                            txnSystem.AddItemToSlot(entity, slotToUse, existingItem, true, null, ERenderingPlane.RPl_Scene, false, false, randomApp);
                            txnSystem.ChangeItemAppearanceByName(entity, existingItem, randomApp);
                        }
                  }
                }
            }
         }
    }
}