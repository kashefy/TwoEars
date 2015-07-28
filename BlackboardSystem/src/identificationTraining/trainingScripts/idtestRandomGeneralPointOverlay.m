function idtestRandomGeneralPointOverlay( classname, testFlist, modelPath )

testpipe = TwoEarsIdTrainPipe();
m = load( fullfile( modelPath, [classname '.model.mat'] ) );
testpipe.featureCreator = m.featureCreator;
testpipe.modelCreator = ...
    modelTrainers.LoadModelNoopTrainer( ...
        @(cn)(fullfile( modelPath, [cn '.model.mat'] )), ...
        'performanceMeasure', @performanceMeasures.BAC2 ...
        );
testpipe.modelCreator.verbose( 'on' );

testpipe.testset = testFlist;

sc = dataProcs.SceneConfiguration();
sc.angleSignal = dataProcs.ValGen('random', [0,359.9]);
sc.distSignal = dataProcs.ValGen('random', [0.5,3]);
sc.addOverlay( ...
    dataProcs.ValGen('random', [0,359.9]), ...
    dataProcs.ValGen('random', [0.5,3]),...
    dataProcs.ValGen('set', [0, 10, 20, 30, 40]), 'point',...
    dataProcs.ValGen('set', testpipe.pipeline.data('general',:,'wavFileName')), ...
    dataProcs.ValGen('random', [0, 2]) );
testpipe.setSceneConfig( [sc] ); 

testpipe.init();
testpipe.pipeline.run( {classname}, 0 );

end