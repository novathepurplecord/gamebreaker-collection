import modchart.Manager;

var mngr:Manager;

function postCreate() {
    for (strum in [cpuStrums, playerStrums]) strum.notes.limit = 2000;

    add(mngr = new Manager());
    setupModifiers();
}

function setupModifiers() {
    mngr.addModifier('CenterRotate');
    mngr.addModifier('FieldRotate');
    mngr.addModifier('OpponentSwap');
    mngr.addModifier('Confusion');
    mngr.addModifier('Invert');
    mngr.addModifier('Infinite');
    mngr.addModifier('Bounce');
    mngr.addModifier('SchmovinTipsy');
    mngr.addModifier('SchmovinDrunk');
    mngr.addModifier('Scale');
    mngr.addModifier('Transform');
    mngr.addModifier('SawTooth');
    mngr.addModifier('Drugged');
    mngr.addModifier('EyeShape');

    mngr.ease("alpha", 68, 1, 0, FlxEase.quadInOut, 1);
    
    mngr.set('bounceY', 68, -2.3, 1);
    mngr.set('Drugged', 68, 1);
    mngr.set('bounceY', 68, 2.3, 0);
    mngr.set('y', 68, -422, 0);
    mngr.set('SawTooth', 68, 1);

    mngr.ease('OpponentSwap', 68, 1, 0.5, FlxEase.quadInOut, 1);

    for (i in 68...100) {
        mngr.set('CenterRotateX', i, 10, 1);
        mngr.ease('CenterRotateX', i, 1, 110, FlxEase.quadInOut, 1);
    }

    mngr.ease('Infinite', 68, 1, 0.8, FlxEase.quadInOut, 0);

    mngr.ease("alpha", 84, 1, 0.2, FlxEase.quadInOut, 0);
    mngr.ease("alpha", 84, 1, 1, FlxEase.quadInOut, 1);

    mngr.set('EyeShape', 131, 1, 1);

    for (i in 131...424) {
        mngr.set('SchmovinTipsy', i, 36.8);
        mngr.ease('SchmovinTipsy', i, 1, 0, FlxEase.quintOut);

        mngr.set('SchmovinDrunk', i, 23.8);
        mngr.ease('SchmovinDrunk', i, 1, 0, FlxEase.quintOut);

        mngr.set('Scale', i, 3.2);
        mngr.ease('Scale', i, 1, 1, FlxEase.quintOut);

        if (i & 1) mngr.set('FieldRotateZ', i, 154);
        else mngr.set('FieldRotateZ', i, -154);
        mngr.ease('FieldRotateZ', i, 1, 0, FlxEase.quintOut);
    }

}

function postUpdate() if (curBeat >= 68) {
    mngr.setPercent('Confusion', Math.sin(Conductor.curBeatFloat * Math.PI - 1) * 0.9, 1);
    mngr.setPercent('Confusion', Math.sin(Conductor.curBeatFloat * Math.PI) * 0.9, 0);
}