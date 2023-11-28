SELECT
  DATE_TRUNC('month', job_first_upload_complete_datetime) AS month,
  COUNT(*) AS number_of_jobs
FROM 
  hover.jobs
GROUP BY 
  month
ORDER BY 
  month

SELECT
  DATE_PART('month', job_first_upload_complete_datetime) AS month,
  COUNT(DISTINCT date_trunc('month', job_first_upload_complete_datetime)) AS count_of_month
FROM 
  hover.jobs
GROUP BY 
  month
ORDER BY 
  month

SELECT
  DATE_TRUNC('month', datetime) AS month,
  COUNT(*) as number_of_events
FROM
  hover.weather
GROUP BY
  month
ORDER BY
  month

SELECT
  DATE_TRUNC('month', datetime) AS month,
  COUNT(*) as number_of_events
FROM
  hover.weather
WHERE
  datetime >= '2016-09-01'
GROUP BY
  month
ORDER BY
  month

SELECT
  DATE_TRUNC('month', datetime) AS month,
  COUNT(*) AS number_of_events
FROM
  hover.weather
WHERE
  datetime >= '2016-09-01'
  and state IN (
    SELECT
      DISTINCT job_location_region_code
    FROM
      hover.jobs
  )
GROUP BY
  month
ORDER BY
  month

SELECT
  DATE_TRUNC('month', w.datetime) AS month,
  COUNT(*) AS number_of_events
FROM
  hover.weather AS w
  JOIN (
    SELECT
      DISTINCT job_location_region_code
    FROM
      hover.jobs
  ) AS j ON w.state = j.job_location_region_code
WHERE
  w.datetime >= '2016-09-01'
GROUP BY
  month
ORDER BY
  month

SELECT
  j.job_deliverable,
  j.job_location_region_code,
  DATE_TRUNC('week', j.job_first_upload_complete_datetime) AS job_week,
  w.n_weather_events
FROM
  hover.jobs as j
  INNER JOIN hover.weekly_weather_events as w 
  ON w.state = j.job_location_region_code
  AND DATE_TRUNC('week', j.job_first_upload_complete_datetime) = w.weather_ts

SELECT
  job_location_region_code,
  job_week,
  COUNT(job_week) AS total_jobs,
  SUM(n_weather_events) AS total_weather_events
FROM
  (
    SELECT
      j.job_deliverable,
      j.job_location_region_code,
      DATE_TRUNC('week', j.job_first_upload_complete_datetime) AS job_week,
      w.n_weather_events
    FROM
      hover.jobs as j
      INNER JOIN hover.weekly_weather_events as w ON w.state = j.job_location_region_code
      AND DATE_TRUNC('week', j.job_first_upload_complete_datetime) = w.weather_ts
  ) AS s
GROUP BY
  job_location_region_code,
  job_week
ORDER BY
  job_location_region_code