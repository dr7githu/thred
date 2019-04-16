/**
 * @fileoverview
 * @enhanceable
 * @suppress {messageConventions} JS Compiler reports an error if a variable or
 *     field starts with 'MSG_' and isn't a translatable message.
 * @public
 */
// GENERATED CODE -- DO NOT EDIT!

goog.provide('proto.vwBuildingDat');
goog.provide('proto.vwBuildingDat.BuildingInfo');

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
proto.vwBuildingDat = function (opt_data)
{
	jspb.Message.initialize(this, opt_data, 0, -1, proto.vwBuildingDat.repeatedFields_, null);
};
goog.inherits(proto.vwBuildingDat, jspb.Message);
if (goog.DEBUG && !COMPILED)
{
	proto.vwBuildingDat.displayName = 'proto.vwBuildingDat';
}
/**
 * List of repeated fields within this message type.
 * @private {!Array<number>}
 * @const
 */
proto.vwBuildingDat.repeatedFields_ = [5];



if (jspb.Message.GENERATE_TO_OBJECT)
{
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
	proto.vwBuildingDat.prototype.toObject = function (opt_includeInstance)
	{
		return proto.vwBuildingDat.toObject(opt_includeInstance, this);
	};


	/**
	 * Static version of the {@see toObject} method.
	 * @param {boolean|undefined} includeInstance Whether to include the JSPB
	 *     instance for transitional soy proto support:
	 *     http://goto/soy-param-migration
	 * @param {!proto.vwBuildingDat} msg The msg instance to transform.
	 * @return {!Object}
	 * @suppress {unusedLocalVariables} f is only used for nested messages
	 */
	proto.vwBuildingDat.toObject = function (includeInstance, msg)
	{
		var f, obj = {
			level: jspb.Message.getFieldWithDefault(msg, 1, 0),
			idx: jspb.Message.getFieldWithDefault(msg, 2, 0),
			idy: jspb.Message.getFieldWithDefault(msg, 3, 0),
			objcount: jspb.Message.getFieldWithDefault(msg, 4, 0),
			buildingList: jspb.Message.toObjectList(msg.getBuildingList(),
				proto.vwBuildingDat.BuildingInfo.toObject, includeInstance)
		};

		if (includeInstance)
		{
			obj.$jspbMessageInstance = msg;
		}
		return obj;
	};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.vwBuildingDat}
 */
proto.vwBuildingDat.deserializeBinary = function (bytes)
{
	var reader = new jspb.BinaryReader(bytes);
	var msg = new proto.vwBuildingDat;
	return proto.vwBuildingDat.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.vwBuildingDat} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.vwBuildingDat}
 */
proto.vwBuildingDat.deserializeBinaryFromReader = function (msg, reader)
{
	while (reader.nextField())
	{
		if (reader.isEndGroup())
		{
			break;
		}
		var field = reader.getFieldNumber();
		switch (field)
		{
			case 1:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setLevel(value);
				break;
			case 2:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setIdx(value);
				break;
			case 3:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setIdy(value);
				break;
			case 4:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setObjcount(value);
				break;
			case 5:
				var value = new proto.vwBuildingDat.BuildingInfo;
				reader.readMessage(value, proto.vwBuildingDat.BuildingInfo.deserializeBinaryFromReader);
				msg.addBuilding(value);
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
proto.vwBuildingDat.prototype.serializeBinary = function ()
{
	var writer = new jspb.BinaryWriter();
	proto.vwBuildingDat.serializeBinaryToWriter(this, writer);
	return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.vwBuildingDat} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.vwBuildingDat.serializeBinaryToWriter = function (message, writer)
{
	var f = undefined;
	f = message.getLevel();
	if (f !== 0)
	{
		writer.writeInt32(
			1,
			f
		);
	}
	f = message.getIdx();
	if (f !== 0)
	{
		writer.writeInt32(
			2,
			f
		);
	}
	f = message.getIdy();
	if (f !== 0)
	{
		writer.writeInt32(
			3,
			f
		);
	}
	f = message.getObjcount();
	if (f !== 0)
	{
		writer.writeInt32(
			4,
			f
		);
	}
	f = message.getBuildingList();
	if (f.length > 0)
	{
		writer.writeRepeatedMessage(
			5,
			f,
			proto.vwBuildingDat.BuildingInfo.serializeBinaryToWriter
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
proto.vwBuildingDat.BuildingInfo = function (opt_data)
{
	jspb.Message.initialize(this, opt_data, 0, -1, null, null);
};
goog.inherits(proto.vwBuildingDat.BuildingInfo, jspb.Message);
if (goog.DEBUG && !COMPILED)
{
	proto.vwBuildingDat.BuildingInfo.displayName = 'proto.vwBuildingDat.BuildingInfo';
}


if (jspb.Message.GENERATE_TO_OBJECT)
{
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
	proto.vwBuildingDat.BuildingInfo.prototype.toObject = function (opt_includeInstance)
	{
		return proto.vwBuildingDat.BuildingInfo.toObject(opt_includeInstance, this);
	};


	/**
	 * Static version of the {@see toObject} method.
	 * @param {boolean|undefined} includeInstance Whether to include the JSPB
	 *     instance for transitional soy proto support:
	 *     http://goto/soy-param-migration
	 * @param {!proto.vwBuildingDat.BuildingInfo} msg The msg instance to transform.
	 * @return {!Object}
	 * @suppress {unusedLocalVariables} f is only used for nested messages
	 */
	proto.vwBuildingDat.BuildingInfo.toObject = function (includeInstance, msg)
	{
		var f, obj = {
			version: jspb.Message.getFieldWithDefault(msg, 1, 0),
			type: jspb.Message.getFieldWithDefault(msg, 2, 0),
			key: jspb.Message.getFieldWithDefault(msg, 3, ""),
			centerposx: +jspb.Message.getFieldWithDefault(msg, 4, 0.0),
			centerposy: +jspb.Message.getFieldWithDefault(msg, 5, 0.0),
			altitude: +jspb.Message.getFieldWithDefault(msg, 6, 0.0),
			boxminx: +jspb.Message.getFieldWithDefault(msg, 7, 0.0),
			boxminy: +jspb.Message.getFieldWithDefault(msg, 8, 0.0),
			boxminz: +jspb.Message.getFieldWithDefault(msg, 9, 0.0),
			boxmaxx: +jspb.Message.getFieldWithDefault(msg, 10, 0.0),
			boxmaxy: +jspb.Message.getFieldWithDefault(msg, 11, 0.0),
			boxmaxz: +jspb.Message.getFieldWithDefault(msg, 12, 0.0),
			imglevel: jspb.Message.getFieldWithDefault(msg, 13, 0),
			datafilename: jspb.Message.getFieldWithDefault(msg, 14, ""),
			imgfilename: jspb.Message.getFieldWithDefault(msg, 15, "")
		};

		if (includeInstance)
		{
			obj.$jspbMessageInstance = msg;
		}
		return obj;
	};
}


/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.vwBuildingDat.BuildingInfo}
 */
proto.vwBuildingDat.BuildingInfo.deserializeBinary = function (bytes)
{
	var reader = new jspb.BinaryReader(bytes);
	var msg = new proto.vwBuildingDat.BuildingInfo;
	return proto.vwBuildingDat.BuildingInfo.deserializeBinaryFromReader(msg, reader);
};


/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.vwBuildingDat.BuildingInfo} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.vwBuildingDat.BuildingInfo}
 */
proto.vwBuildingDat.BuildingInfo.deserializeBinaryFromReader = function (msg, reader)
{
	while (reader.nextField())
	{
		if (reader.isEndGroup())
		{
			break;
		}
		var field = reader.getFieldNumber();
		switch (field)
		{
			case 1:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setVersion(value);
				break;
			case 2:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setType(value);
				break;
			case 3:
				var value = /** @type {string} */ (reader.readString());
				msg.setKey(value);
				break;
			case 4:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setCenterposx(value);
				break;
			case 5:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setCenterposy(value);
				break;
			case 6:
				var value = /** @type {number} */ (reader.readFloat());
				msg.setAltitude(value);
				break;
			case 7:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setBoxminx(value);
				break;
			case 8:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setBoxminy(value);
				break;
			case 9:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setBoxminz(value);
				break;
			case 10:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setBoxmaxx(value);
				break;
			case 11:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setBoxmaxy(value);
				break;
			case 12:
				var value = /** @type {number} */ (reader.readDouble());
				msg.setBoxmaxz(value);
				break;
			case 13:
				var value = /** @type {number} */ (reader.readInt32());
				msg.setImglevel(value);
				break;
			case 14:
				var value = /** @type {string} */ (reader.readString());
				msg.setDatafilename(value);
				break;
			case 15:
				var value = /** @type {string} */ (reader.readString());
				msg.setImgfilename(value);
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
proto.vwBuildingDat.BuildingInfo.prototype.serializeBinary = function ()
{
	var writer = new jspb.BinaryWriter();
	proto.vwBuildingDat.BuildingInfo.serializeBinaryToWriter(this, writer);
	return writer.getResultBuffer();
};


/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.vwBuildingDat.BuildingInfo} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */
proto.vwBuildingDat.BuildingInfo.serializeBinaryToWriter = function (message, writer)
{
	var f = undefined;
	f = message.getVersion();
	if (f !== 0)
	{
		writer.writeInt32(
			1,
			f
		);
	}
	f = message.getType();
	if (f !== 0)
	{
		writer.writeInt32(
			2,
			f
		);
	}
	f = message.getKey();
	if (f.length > 0)
	{
		writer.writeString(
			3,
			f
		);
	}
	f = message.getCenterposx();
	if (f !== 0.0)
	{
		writer.writeDouble(
			4,
			f
		);
	}
	f = message.getCenterposy();
	if (f !== 0.0)
	{
		writer.writeDouble(
			5,
			f
		);
	}
	f = message.getAltitude();
	if (f !== 0.0)
	{
		writer.writeFloat(
			6,
			f
		);
	}
	f = message.getBoxminx();
	if (f !== 0.0)
	{
		writer.writeDouble(
			7,
			f
		);
	}
	f = message.getBoxminy();
	if (f !== 0.0)
	{
		writer.writeDouble(
			8,
			f
		);
	}
	f = message.getBoxminz();
	if (f !== 0.0)
	{
		writer.writeDouble(
			9,
			f
		);
	}
	f = message.getBoxmaxx();
	if (f !== 0.0)
	{
		writer.writeDouble(
			10,
			f
		);
	}
	f = message.getBoxmaxy();
	if (f !== 0.0)
	{
		writer.writeDouble(
			11,
			f
		);
	}
	f = message.getBoxmaxz();
	if (f !== 0.0)
	{
		writer.writeDouble(
			12,
			f
		);
	}
	f = message.getImglevel();
	if (f !== 0)
	{
		writer.writeInt32(
			13,
			f
		);
	}
	f = message.getDatafilename();
	if (f.length > 0)
	{
		writer.writeString(
			14,
			f
		);
	}
	f = message.getImgfilename();
	if (f.length > 0)
	{
		writer.writeString(
			15,
			f
		);
	}
};


/**
 * optional int32 version = 1;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getVersion = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 1, 0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setVersion = function (value)
{
	jspb.Message.setProto3IntField(this, 1, value);
};


/**
 * optional int32 type = 2;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getType = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 2, 0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setType = function (value)
{
	jspb.Message.setProto3IntField(this, 2, value);
};


/**
 * optional string key = 3;
 * @return {string}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getKey = function ()
{
	return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 3, ""));
};


/** @param {string} value */
proto.vwBuildingDat.BuildingInfo.prototype.setKey = function (value)
{
	jspb.Message.setProto3StringField(this, 3, value);
};


/**
 * optional double centerPosX = 4;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getCenterposx = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 4, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setCenterposx = function (value)
{
	jspb.Message.setProto3FloatField(this, 4, value);
};


/**
 * optional double centerPosY = 5;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getCenterposy = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 5, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setCenterposy = function (value)
{
	jspb.Message.setProto3FloatField(this, 5, value);
};


/**
 * optional float altitude = 6;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getAltitude = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 6, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setAltitude = function (value)
{
	jspb.Message.setProto3FloatField(this, 6, value);
};


/**
 * optional double boxminX = 7;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getBoxminx = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 7, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setBoxminx = function (value)
{
	jspb.Message.setProto3FloatField(this, 7, value);
};


/**
 * optional double boxminY = 8;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getBoxminy = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 8, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setBoxminy = function (value)
{
	jspb.Message.setProto3FloatField(this, 8, value);
};


/**
 * optional double boxminZ = 9;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getBoxminz = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 9, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setBoxminz = function (value)
{
	jspb.Message.setProto3FloatField(this, 9, value);
};


/**
 * optional double boxmaxX = 10;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getBoxmaxx = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 10, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setBoxmaxx = function (value)
{
	jspb.Message.setProto3FloatField(this, 10, value);
};


/**
 * optional double boxmaxY = 11;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getBoxmaxy = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 11, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setBoxmaxy = function (value)
{
	jspb.Message.setProto3FloatField(this, 11, value);
};


/**
 * optional double boxmaxZ = 12;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getBoxmaxz = function ()
{
	return /** @type {number} */ (+jspb.Message.getFieldWithDefault(this, 12, 0.0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setBoxmaxz = function (value)
{
	jspb.Message.setProto3FloatField(this, 12, value);
};


/**
 * optional int32 imgLevel = 13;
 * @return {number}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getImglevel = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 13, 0));
};


/** @param {number} value */
proto.vwBuildingDat.BuildingInfo.prototype.setImglevel = function (value)
{
	jspb.Message.setProto3IntField(this, 13, value);
};


/**
 * optional string dataFileName = 14;
 * @return {string}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getDatafilename = function ()
{
	return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 14, ""));
};


/** @param {string} value */
proto.vwBuildingDat.BuildingInfo.prototype.setDatafilename = function (value)
{
	jspb.Message.setProto3StringField(this, 14, value);
};


/**
 * optional string imgFileName = 15;
 * @return {string}
 */
proto.vwBuildingDat.BuildingInfo.prototype.getImgfilename = function ()
{
	return /** @type {string} */ (jspb.Message.getFieldWithDefault(this, 15, ""));
};


/** @param {string} value */
proto.vwBuildingDat.BuildingInfo.prototype.setImgfilename = function (value)
{
	jspb.Message.setProto3StringField(this, 15, value);
};


/**
 * optional int32 level = 1;
 * @return {number}
 */
proto.vwBuildingDat.prototype.getLevel = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 1, 0));
};


/** @param {number} value */
proto.vwBuildingDat.prototype.setLevel = function (value)
{
	jspb.Message.setProto3IntField(this, 1, value);
};


/**
 * optional int32 idx = 2;
 * @return {number}
 */
proto.vwBuildingDat.prototype.getIdx = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 2, 0));
};


/** @param {number} value */
proto.vwBuildingDat.prototype.setIdx = function (value)
{
	jspb.Message.setProto3IntField(this, 2, value);
};


/**
 * optional int32 idy = 3;
 * @return {number}
 */
proto.vwBuildingDat.prototype.getIdy = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 3, 0));
};


/** @param {number} value */
proto.vwBuildingDat.prototype.setIdy = function (value)
{
	jspb.Message.setProto3IntField(this, 3, value);
};


/**
 * optional int32 objCount = 4;
 * @return {number}
 */
proto.vwBuildingDat.prototype.getObjcount = function ()
{
	return /** @type {number} */ (jspb.Message.getFieldWithDefault(this, 4, 0));
};


/** @param {number} value */
proto.vwBuildingDat.prototype.setObjcount = function (value)
{
	jspb.Message.setProto3IntField(this, 4, value);
};


/**
 * repeated BuildingInfo building = 5;
 * @return {!Array.<!proto.vwBuildingDat.BuildingInfo>}
 */
proto.vwBuildingDat.prototype.getBuildingList = function ()
{
	return /** @type{!Array.<!proto.vwBuildingDat.BuildingInfo>} */ (
		jspb.Message.getRepeatedWrapperField(this, proto.vwBuildingDat.BuildingInfo, 5));
};


/** @param {!Array.<!proto.vwBuildingDat.BuildingInfo>} value */
proto.vwBuildingDat.prototype.setBuildingList = function (value)
{
	jspb.Message.setRepeatedWrapperField(this, 5, value);
};


/**
 * @param {!proto.vwBuildingDat.BuildingInfo=} opt_value
 * @param {number=} opt_index
 * @return {!proto.vwBuildingDat.BuildingInfo}
 */
proto.vwBuildingDat.prototype.addBuilding = function (opt_value, opt_index)
{
	return jspb.Message.addToRepeatedWrapperField(this, 5, opt_value, proto.vwBuildingDat.BuildingInfo, opt_index);
};


proto.vwBuildingDat.prototype.clearBuildingList = function ()
{
	this.setBuildingList([]);
};


