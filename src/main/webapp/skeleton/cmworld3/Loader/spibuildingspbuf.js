/**
 * @fileoverview
 * @enhanceable
 * @suppress {messageConventions} JS Compiler reports an error if a variable or
 *     field starts with 'MSG_' and isn't a translatable message.
 * @public
 */
// GENERATED CODE -- DO NOT EDIT!

goog.provide('proto.spiBuildingsPBuf');
goog.provide('proto.spiBuildingsPBuf.spiBuildingSummaryPBuf');

goog.require('jspb.BinaryReader');
goog.require('jspb.BinaryWriter');
goog.require('jspb.Message');


/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.spiBuildingsPBuf = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, proto.spiBuildingsPBuf.repeatedFields_, null);
};
goog.inherits(proto.spiBuildingsPBuf, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.spiBuildingsPBuf.displayName = 'proto.spiBuildingsPBuf';
}
/**
 * List of repeated fields within this message type.
 * @private {!Array<number>}
 * @const
 */
proto.spiBuildingsPBuf.repeatedFields_ = [5];



if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.spiBuildingsPBuf.prototype.toObject = function(opt_includeInstance) {
  return proto.spiBuildingsPBuf.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.spiBuildingsPBuf} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.spiBuildingsPBuf.toObject = function(includeInstance, msg) {
  var f, obj = {
    version: jspb.Message.getFieldWithDefault(msg, 1, 0),
    level: jspb.Message.getFieldWithDefault(msg, 2, 0),
    idx: jspb.Message.getFieldWithDefault(msg, 3, 0),
    idy: jspb.Message.getFieldWithDefault(msg, 4, 0),
    objarrayList: jspb.Message.toObjectList(msg.getObjarrayList(),
    proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.toObject, includeInstance)
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.spiBuildingsPBuf}
 */
proto.spiBuildingsPBuf.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.spiBuildingsPBuf;
  return proto.spiBuildingsPBuf.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.spiBuildingsPBuf} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.spiBuildingsPBuf}
 */
proto.spiBuildingsPBuf.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {number} */ (reader.readInt32());
      msg.setVersion(value);
      break;
    case 2:
      var value = /** @type {number} */ (reader.readInt32());
      msg.setLevel(value);
      break;
    case 3:
      var value = /** @type {number} */ (reader.readInt32());
      msg.setIdx(value);
      break;
    case 4:
      var value = /** @type {number} */ (reader.readInt32());
      msg.setIdy(value);
      break;
    case 5:
      var value = new proto.spiBuildingsPBuf.spiBuildingSummaryPBuf;
      reader.readMessage(value,proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.deserializeBinaryFromReader);
      msg.addObjarray(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.spiBuildingsPBuf.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.spiBuildingsPBuf.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.spiBuildingsPBuf} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.spiBuildingsPBuf.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getVersion();
  if (f !== 0) {
    writer.writeInt32(
      1,
      f
    );
  }
  f = message.getLevel();
  if (f !== 0) {
    writer.writeInt32(
      2,
      f
    );
  }
  f = message.getIdx();
  if (f !== 0) {
    writer.writeInt32(
      3,
      f
    );
  }
  f = message.getIdy();
  if (f !== 0) {
    writer.writeInt32(
      4,
      f
    );
  }
  f = message.getObjarrayList();
  if (f.length > 0) {
    writer.writeRepeatedMessage(
      5,
      f,
      proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.serializeBinaryToWriter
    );
  }
};



/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf = function(opt_data) {
  jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.spiBuildingsPBuf.spiBuildingSummaryPBuf, jspb.Message);
if (goog.DEBUG && !COMPILED) {
  proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.displayName = 'proto.spiBuildingsPBuf.spiBuildingSummaryPBuf';
}


if (jspb.Message.GENERATE_TO_OBJECT) {
/**
 * Creates an object representation of this proto suitable for use in Soy templates.
 * Field names that are reserved in JavaScript and will be renamed to pb_name.
 * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
 * For the list of reserved names please see:
 *     com.google.apps.jspb.JsClassTemplate.JS_RESERVED_WORDS.
 * @param {boolean=} opt_includeInstance Whether to include the JSPB instance
 *     for transitional soy proto support: http://goto/soy-param-migration
 * @return {!Object}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.toObject = function(opt_includeInstance) {
  return proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.toObject(opt_includeInstance, this);
};


/**
 * Static version of the {@see toObject} method.
 * @param {boolean|undefined} includeInstance Whether to include the JSPB
 *     instance for transitional soy proto support:
 *     http://goto/soy-param-migration
 * @param {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf} msg The msg instance to transform.
 * @return {!Object}
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.toObject = function(includeInstance, msg) {
  var f, obj = {
    type: jspb.Message.getFieldWithDefault(msg, 1, 0),
    key: jspb.Message.getFieldWithDefault(msg, 2, ""),
    centerposx: +jspb.Message.getFieldWithDefault(msg, 3, 0.0),
    centerposy: +jspb.Message.getFieldWithDefault(msg, 4, 0.0),
    altitude: +jspb.Message.getFieldWithDefault(msg, 5, 0.0),
    boxminx: +jspb.Message.getFieldWithDefault(msg, 6, 0.0),
    boxminy: +jspb.Message.getFieldWithDefault(msg, 7, 0.0),
    boxminz: +jspb.Message.getFieldWithDefault(msg, 8, 0.0),
    boxmaxx: +jspb.Message.getFieldWithDefault(msg, 9, 0.0),
    boxmaxy: +jspb.Message.getFieldWithDefault(msg, 10, 0.0),
    boxmaxz: +jspb.Message.getFieldWithDefault(msg, 11, 0.0),
    datafilename: jspb.Message.getFieldWithDefault(msg, 12, "")
  };

  if (includeInstance) {
    obj.$jspbMessageInstance = msg;
  }
  return obj;
};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.deserializeBinary = function(bytes) {
  var reader = new jspb.BinaryReader(bytes);
  var msg = new proto.spiBuildingsPBuf.spiBuildingSummaryPBuf;
  return proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.deserializeBinaryFromReader = function(msg, reader) {
  while (reader.nextField()) {
    if (reader.isEndGroup()) {
      break;
    }
    var field = reader.getFieldNumber();
    switch (field) {
    case 1:
      var value = /** @type {number} */ (reader.readInt32());
      msg.setType(value);
      break;
    case 2:
      var value = /** @type {string} */ (reader.readString());
      msg.setKey(value);
      break;
    case 3:
      var value = /** @type {number} */ (reader.readDouble());
      msg.setCenterposx(value);
      break;
    case 4:
      var value = /** @type {number} */ (reader.readDouble());
      msg.setCenterposy(value);
      break;
    case 5:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setAltitude(value);
      break;
    case 6:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setBoxminx(value);
      break;
    case 7:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setBoxminy(value);
      break;
    case 8:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setBoxminz(value);
      break;
    case 9:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setBoxmaxx(value);
      break;
    case 10:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setBoxmaxy(value);
      break;
    case 11:
      var value = /** @type {number} */ (reader.readFloat());
      msg.setBoxmaxz(value);
      break;
    case 12:
      var value = /** @type {string} */ (reader.readString());
      msg.setDatafilename(value);
      break;
    default:
      reader.skipField();
      break;
    }
  }
  return msg;
};


/**
 * Serializes the message to binary data (in protobuf wire format).
 * @return {!Uint8Array}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.serializeBinary = function() {
  var writer = new jspb.BinaryWriter();
  proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.serializeBinaryToWriter(this, writer);
  return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.serializeBinaryToWriter = function(message, writer) {
  var f = undefined;
  f = message.getType();
  if (f !== 0) {
    writer.writeInt32(
      1,
      f
    );
  }
  f = message.getKey();
  if (f.length > 0) {
    writer.writeString(
      2,
      f
    );
  }
  f = message.getCenterposx();
  if (f !== 0.0) {
    writer.writeDouble(
      3,
      f
    );
  }
  f = message.getCenterposy();
  if (f !== 0.0) {
    writer.writeDouble(
      4,
      f
    );
  }
  f = message.getAltitude();
  if (f !== 0.0) {
    writer.writeFloat(
      5,
      f
    );
  }
  f = message.getBoxminx();
  if (f !== 0.0) {
    writer.writeFloat(
      6,
      f
    );
  }
  f = message.getBoxminy();
  if (f !== 0.0) {
    writer.writeFloat(
      7,
      f
    );
  }
  f = message.getBoxminz();
  if (f !== 0.0) {
    writer.writeFloat(
      8,
      f
    );
  }
  f = message.getBoxmaxx();
  if (f !== 0.0) {
    writer.writeFloat(
      9,
      f
    );
  }
  f = message.getBoxmaxy();
  if (f !== 0.0) {
    writer.writeFloat(
      10,
      f
    );
  }
  f = message.getBoxmaxz();
  if (f !== 0.0) {
    writer.writeFloat(
      11,
      f
    );
  }
  f = message.getDatafilename();
  if (f.length > 0) {
    writer.writeString(
      12,
      f
    );
  }
};


/**
 * optional int32 type = 1;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getType = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 1, 0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setType = function(value) {
  jspb.Message.setProto3IntField(this, 1, value);
};


/**
 * optional string key = 2;
 * @return {string}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getKey = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 2, ""));
};


/** @param {string} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setKey = function(value) {
  jspb.Message.setProto3StringField(this, 2, value);
};


/**
 * optional double centerPosX = 3;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getCenterposx = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 3, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setCenterposx = function(value) {
  jspb.Message.setProto3FloatField(this, 3, value);
};


/**
 * optional double centerPosY = 4;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getCenterposy = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 4, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setCenterposy = function(value) {
  jspb.Message.setProto3FloatField(this, 4, value);
};


/**
 * optional float altitude = 5;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getAltitude = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 5, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setAltitude = function(value) {
  jspb.Message.setProto3FloatField(this, 5, value);
};


/**
 * optional float boxminX = 6;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getBoxminx = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 6, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setBoxminx = function(value) {
  jspb.Message.setProto3FloatField(this, 6, value);
};


/**
 * optional float boxminY = 7;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getBoxminy = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 7, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setBoxminy = function(value) {
  jspb.Message.setProto3FloatField(this, 7, value);
};


/**
 * optional float boxminZ = 8;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getBoxminz = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 8, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setBoxminz = function(value) {
  jspb.Message.setProto3FloatField(this, 8, value);
};


/**
 * optional float boxmaxX = 9;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getBoxmaxx = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 9, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setBoxmaxx = function(value) {
  jspb.Message.setProto3FloatField(this, 9, value);
};


/**
 * optional float boxmaxY = 10;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getBoxmaxy = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 10, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setBoxmaxy = function(value) {
  jspb.Message.setProto3FloatField(this, 10, value);
};


/**
 * optional float boxmaxZ = 11;
 * @return {number}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getBoxmaxz = function() {
  return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 11, 0.0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setBoxmaxz = function(value) {
  jspb.Message.setProto3FloatField(this, 11, value);
};


/**
 * optional string dataFileName = 12;
 * @return {string}
 */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.getDatafilename = function() {
  return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 12, ""));
};


/** @param {string} value */
proto.spiBuildingsPBuf.spiBuildingSummaryPBuf.prototype.setDatafilename = function(value) {
  jspb.Message.setProto3StringField(this, 12, value);
};


/**
 * optional int32 version = 1;
 * @return {number}
 */
proto.spiBuildingsPBuf.prototype.getVersion = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 1, 0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.prototype.setVersion = function(value) {
  jspb.Message.setProto3IntField(this, 1, value);
};


/**
 * optional int32 level = 2;
 * @return {number}
 */
proto.spiBuildingsPBuf.prototype.getLevel = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 2, 0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.prototype.setLevel = function(value) {
  jspb.Message.setProto3IntField(this, 2, value);
};


/**
 * optional int32 idx = 3;
 * @return {number}
 */
proto.spiBuildingsPBuf.prototype.getIdx = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 3, 0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.prototype.setIdx = function(value) {
  jspb.Message.setProto3IntField(this, 3, value);
};


/**
 * optional int32 idy = 4;
 * @return {number}
 */
proto.spiBuildingsPBuf.prototype.getIdy = function() {
  return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 4, 0));
};


/** @param {number} value */
proto.spiBuildingsPBuf.prototype.setIdy = function(value) {
  jspb.Message.setProto3IntField(this, 4, value);
};


/**
 * repeated spiBuildingSummaryPBuf objarray = 5;
 * @return {!Array.<!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf>}
 */
proto.spiBuildingsPBuf.prototype.getObjarrayList = function() {
  return /** @type{!Array.<!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf>} */ (
    jspb.Message.getRepeatedWrapperField(this, proto.spiBuildingsPBuf.spiBuildingSummaryPBuf, 5));
};


/** @param {!Array.<!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf>} value */
proto.spiBuildingsPBuf.prototype.setObjarrayList = function(value) {
  jspb.Message.setRepeatedWrapperField(this, 5, value);
};


/**
 * @param {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf=} opt_value
 * @param {number=} opt_index
 * @return {!proto.spiBuildingsPBuf.spiBuildingSummaryPBuf}
 */
proto.spiBuildingsPBuf.prototype.addObjarray = function(opt_value, opt_index) {
  return jspb.Message.addToRepeatedWrapperField(this, 5, opt_value, proto.spiBuildingsPBuf.spiBuildingSummaryPBuf, opt_index);
};


proto.spiBuildingsPBuf.prototype.clearObjarrayList = function() {
  this.setObjarrayList([]);
};


