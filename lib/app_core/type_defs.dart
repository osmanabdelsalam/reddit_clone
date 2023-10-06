import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/app_core/failure.dart';


typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;