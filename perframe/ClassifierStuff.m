classdef ClassifierStuff < handle
  % Class that includes the classifier plus classifier metadata, like the
  % classifier training parameters
  properties
    type
    params
    timeStamp
    confThresholds
    scoreNorm
    postProcessParams
    trainingParams
    featureNames
    windowdata
    savewindowdata
  end  % properties
  methods
    function self=ClassifierStuff(varargin)
      % set default values
      self.type='boosting';
      self.params=struct('dim',{}, ...
                         'error',{}, ...
                         'dir',{}, ....
                         'tr',{}, ...
                         'alpha',{});  % 0x1 struct array
      self.timeStamp=0;  % default time stamp (bad idea?)
      self.confThresholds=[0 0];
      self.scoreNorm=0;  % default time stamp, number of days since Jan 0, 0000 (typically non-integer)
      self.postProcessParams.method = 'Hysteresis';
      self.postProcessParams.hystopts(1) = struct('name','High Threshold','tag','hthres','value',0);
      self.postProcessParams.hystopts(2) = struct('name','Low Threshold','tag','lthres','value',0);
      self.postProcessParams.filtopts(1) = struct('name','Size','tag','size','value',1);
      self.postProcessParams.blen = 1;
      self.trainingParams= ...
        struct('iter',100, ...
               'iter_updates',10, ...
               'numSample',2500, ...
               'numBins',30, ...
               'CVfolds',7, ...
               'baseClassifierTypes','Decision Stumps', ...
               'baseClassifierSelected',1);
      self.featureNames = {};
      self.windowdata =         struct('X',single([]),'exp',[],'flies',[],'t',[],...
               'labelidx_cur',[],'labelidx_new',[],'labelidx_old',[],...
               'labelidx_imp',[],'featurenames',{{}},...
               'predicted',[],'predicted_probs',[],'isvalidprediction',[],...
               'distNdx',[],'scores',[],'scoreNorm',[],'binVals',[],...
               'scores_old',[],'scores_validated',[],'postprocessed',[]);
      self.savewindowdata = false;
      % varargin should be key-value pairs
      % Keys should be property names, values should be initialization
      % values for the corresponding property
      keys=varargin(1:2:end);
      values=varargin(2:2:end);
      
      % Process the keys, assigning to any that match properties, and
      % throwing an error if a key matches no property
      propertyNames=properties(self);
      for iKey=1:length(keys)
        key=keys{iKey};
        iProperty=whichstr(key,propertyNames);
        if isempty(iProperty) ,
          error('Classifier:noPropertyMatchingKey', ...
                sprintf('Classifier: No property matching key %s',key));
        else
          propertyName=propertyNames{iProperty};
          value=values{iKey};
          self.(propertyName)=value;
        end
      end  % for loop
    end  % constructor    
  end  % methods
end  % classdef
