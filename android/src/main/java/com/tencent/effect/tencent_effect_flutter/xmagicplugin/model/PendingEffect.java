package com.tencent.effect.tencent_effect_flutter.xmagicplugin.model;

import java.util.Map;

/**
 * 待设置的effect数据模型
 */
public class PendingEffect {
    public final String effectName;
    public final int effectValue;
    public final String resourcePath;
    public final Map<String, String> extraInfo;

    public PendingEffect(String effectName, int effectValue, String resourcePath, Map<String, String> extraInfo) {
        this.effectName = effectName;
        this.effectValue = effectValue;
        this.resourcePath = resourcePath;
        this.extraInfo = extraInfo;
    }
}
