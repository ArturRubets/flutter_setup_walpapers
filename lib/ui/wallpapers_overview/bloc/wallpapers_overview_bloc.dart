import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wallpapers_overview_event.dart';
part 'wallpapers_overview_state.dart';

class WallpapersOverviewBloc extends Bloc<WallpapersOverviewEvent, WallpapersOverviewState> {
  WallpapersOverviewBloc() : super(WallpapersOverviewInitial()) {
    on<WallpapersOverviewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
