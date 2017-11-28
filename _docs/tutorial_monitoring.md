---
layout: docs
title: Monitoring
---

# Monitoring

As Cloudiator implements the MAPE-K loop[], we provide internally to keep track of the state of the system. In this step, we show you how to monitor your applications.

In this example, we assume that you have the aforementioned wiki application[] running. In Cloudiator you can monitor your application with raw monitors and composed monitors. Raw monitors capture raw metrics, which means here we apply agents that directly queries unaltered monitoring data, e.g. from the component or the node directly. Composed monitors are aggregation processes that use raw monitoring data as input and process them to higher level data.

## Raw Monitoring

In this section, we will monitor the components of the wiki application in terms of raw CPU data. For this we create a raw monitor. A raw monitor consists of the description of the sensor, and filter values that define what component instances will be monitored. 

### Creating a Sensor Description

The sensor description is used to determine the class and the schedule of the crawler in the monitoring engine, which is Visor[].

The following sensor description defines a CPU crawler with a schedule of 1 seconds. The schedule has to be created beforehand as own entity. Please note the ID of the schedule.

colosseum-client
```
```

REST
```
{
    "interval" : 10,
    "timeUnit" : "TimeUnit.SECONDS"
}
```

UI
```
```

Now we can create the sensor description

colosseum-client
```
```

REST
```
{
    "className" : "de.uniulm.omi.cloudiator.visor.sensors.SystemCpuUsageSensor",
    "isVmSensor" : "true",
    "metricName" : "wikiCpuUsage"
}
```

UI
```
```


### Creating a Sensor Configuration

A sensor configuration holds meta data that configures the sensor itself (e.g. credetials) or meta data that will be pushed to the time-series database to which the monitoring agent pushes the metrics. In our case it is empty.

colosseum-client
```
```

REST
```
{}
```

UI
```
```

### Creating the Raw Monitor

Now we can create the RawMonitor entity which combines the above mentioned entities.

colosseum-client
```
```

REST
```
{
    "component" : /* insert the ID of the wiki component */,
    "schedule" : /* insert the ID of the schedule from above */,
    "sensorConfigurations" : /* insert the ID of the sensor configuration from above */,
    "sensorDescription" : /* insert the ID of the sensor description from above */,
}
```

UI
```
```

Now we monitor the CPU usage of all instances of the wiki component!


## Composed Monitoring

The above monitoring is already quite nice and can give hints to the quality of service of the system and its healthiness. But it also requires to interpret the data manually from thousands of individual measurements.
