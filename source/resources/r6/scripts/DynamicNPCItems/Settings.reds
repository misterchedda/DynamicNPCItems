module MisterChedda.DynamicNPCItems

public class DynamicNPCItemSettings extends ScriptableSystem {

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-enable")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-enable-desc")
    let enabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.category", "UI-MChedda-DynamicNPCItems-cat-frequency")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-name-frequency")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-desc-frequency")
    @runtimeProperty("ModSettings.step", "10")
    @runtimeProperty("ModSettings.min", "10")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.dependency", "enabled")
    let itemFrequency: Float = 80.0;

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.category", "UI-MChedda-DynamicNPCItems-cat-items")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-name-cellphoneTablet")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-desc-cellphoneTablet")
    @runtimeProperty("ModSettings.dependency", "enabled")
    let useCellphoneTablet: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.category", "UI-MChedda-DynamicNPCItems-cat-items")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-name-can")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-desc-can")
    @runtimeProperty("ModSettings.dependency", "enabled")
    let useCan: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.category", "UI-MChedda-DynamicNPCItems-cat-items")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-name-bag")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-desc-bag")
    @runtimeProperty("ModSettings.dependency", "enabled")
    let useBag: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.category", "UI-MChedda-DynamicNPCItems-cat-items")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-name-cigarette")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-desc-cigarette")
    @runtimeProperty("ModSettings.dependency", "enabled")
    let useCigarette: Bool = false;

    @runtimeProperty("ModSettings.mod", "UI-MChedda-DynamicNPCItems-title")
    @runtimeProperty("ModSettings.category", "UI-MChedda-DynamicNPCItems-cat-items")
    @runtimeProperty("ModSettings.displayName", "UI-MChedda-DynamicNPCItems-name-umbrella")
    @runtimeProperty("ModSettings.description", "UI-MChedda-DynamicNPCItems-desc-umbrella")
    @runtimeProperty("ModSettings.dependency", "enabled")
    let useUmbrella: Bool = false;

    public static func Get(gi: GameInstance) -> ref<DynamicNPCItemSettings> {
        return GameInstance.GetScriptableSystemsContainer(gi).Get(n"MisterChedda.DynamicNPCItems.DynamicNPCItemSettings") as DynamicNPCItemSettings;
    }

    @if(ModuleExists("ModSettingsModule"))
    private func OnAttach() -> Void {
        ModSettings.RegisterListenerToClass(this);
        ModSettings.RegisterListenerToModifications(this);
    }

    @if(!ModuleExists("ModSettingsModule"))
    private func OnAttach() -> Void {
    }

    @if(ModuleExists("ModSettingsModule"))
    private func OnModSettingsChange() -> Void {
    }

    @if(ModuleExists("ModSettingsModule"))
    private func OnDetach() -> Void {
        ModSettings.UnregisterListenerToClass(this);
        ModSettings.UnregisterListenerToModifications(this);
    }

    @if(!ModuleExists("ModSettingsModule"))
    private func OnDetach() -> Void {
    }
}