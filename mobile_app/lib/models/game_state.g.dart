// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameProgressAdapter extends TypeAdapter<GameProgress> {
  @override
  final int typeId = 2;

  @override
  GameProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameProgress(
      currentState: fields[0] as GameState,
      currentContext: fields[1] as GameContext,
      stateData: (fields[2] as Map).cast<String, dynamic>(),
      lastUpdated: fields[3] as DateTime,
      score: fields[4] as int,
      completedObjectives: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameProgress obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.currentState)
      ..writeByte(1)
      ..write(obj.currentContext)
      ..writeByte(2)
      ..write(obj.stateData)
      ..writeByte(3)
      ..write(obj.lastUpdated)
      ..writeByte(4)
      ..write(obj.score)
      ..writeByte(5)
      ..write(obj.completedObjectives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameStateAdapter extends TypeAdapter<GameState> {
  @override
  final int typeId = 0;

  @override
  GameState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameState.splash;
      case 1:
        return GameState.forestAdventure;
      case 2:
        return GameState.castleExploration;
      case 3:
        return GameState.drawingGame;
      case 4:
        return GameState.colorLearning;
      case 5:
        return GameState.numberLearning;
      case 6:
        return GameState.shapeLearning;
      case 7:
        return GameState.completed;
      default:
        return GameState.splash;
    }
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    switch (obj) {
      case GameState.splash:
        writer.writeByte(0);
        break;
      case GameState.forestAdventure:
        writer.writeByte(1);
        break;
      case GameState.castleExploration:
        writer.writeByte(2);
        break;
      case GameState.drawingGame:
        writer.writeByte(3);
        break;
      case GameState.colorLearning:
        writer.writeByte(4);
        break;
      case GameState.numberLearning:
        writer.writeByte(5);
        break;
      case GameState.shapeLearning:
        writer.writeByte(6);
        break;
      case GameState.completed:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameContextAdapter extends TypeAdapter<GameContext> {
  @override
  final int typeId = 1;

  @override
  GameContext read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameContext.introduction;
      case 1:
        return GameContext.puzzleSolving;
      case 2:
        return GameContext.objectFinding;
      case 3:
        return GameContext.learningActivity;
      case 4:
        return GameContext.encouragement;
      case 5:
        return GameContext.celebration;
      case 6:
        return GameContext.helpRequest;
      default:
        return GameContext.introduction;
    }
  }

  @override
  void write(BinaryWriter writer, GameContext obj) {
    switch (obj) {
      case GameContext.introduction:
        writer.writeByte(0);
        break;
      case GameContext.puzzleSolving:
        writer.writeByte(1);
        break;
      case GameContext.objectFinding:
        writer.writeByte(2);
        break;
      case GameContext.learningActivity:
        writer.writeByte(3);
        break;
      case GameContext.encouragement:
        writer.writeByte(4);
        break;
      case GameContext.celebration:
        writer.writeByte(5);
        break;
      case GameContext.helpRequest:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameContextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
