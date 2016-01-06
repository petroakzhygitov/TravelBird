source 'https://github.com/CocoaPods/Specs.git'
xcodeproj 'NestTravel.xcodeproj'
link_with 'NestTravel', 'NestTravelTests'

target :NestTravel do
  pod 'CocoaLumberjack'
  pod 'ReactiveCocoa', '~> 2'
  pod 'JSONModel'
  pod 'Firebase', '1.2.3'

  # Nest authorization works super slow (around 2 mins! for response) with latest Firebase 2.5.0
  # It doesn't look good by the way
  #pod 'Firebase', '>= 2.5.0'

  pod "HTMLReader"
  pod 'SSKeychain'
end

target :NestTravelTests, :exclusive => true do
  pod 'Specta', '~> 1.0'
  pod 'Expecta', '~> 1.0.0'
  pod 'Nocilla', '~> 0.10.0'
  pod 'OCMock'
end